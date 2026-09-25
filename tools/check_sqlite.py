"""Build the database in SQLite from the SQL Server scripts and run the queries.

SQL Server is the real target, but not everyone has it installed. This loads
sql/01_schema.sql and sql/02_data.sql into an in-memory SQLite database with
foreign keys switched on, checks that every foreign key and check constraint
holds, then runs each query in sql/03_queries.sql and prints the result.

Usage: python tools/check_sqlite.py          (Python 3.9+, no packages needed)
"""
import re
import sqlite3
import sys
from pathlib import Path

SQL_DIR = Path(__file__).resolve().parent.parent / "sql"
EXPECTED_ROWS = 251


def read(name):
    text = (SQL_DIR / name).read_text(encoding="utf-8")
    # The only T-SQL that SQLite doesn't accept here: N'...' literals.
    return re.sub(r"\bN'", "'", text)


def split_queries(text):
    """Return (title, sql) pairs; each query starts at a '-- Q<n>.' line."""
    parts = re.split(r"^-- (Q\d+\..*)$", text, flags=re.M)
    return [(title, body.strip()) for title, body in zip(parts[1::2], parts[2::2])]


def show(cursor, rows):
    names = [c[0] for c in cursor.description]
    table = [names] + [["" if v is None else str(v) for v in row] for row in rows]
    widths = [max(len(r[i]) for r in table) for i in range(len(names))]
    for k, r in enumerate(table):
        print("  " + "  ".join(v.ljust(w) for v, w in zip(r, widths)))
        if k == 0:
            print("  " + "  ".join("-" * w for w in widths))
    if not rows:
        print("  (no rows)")


def main():
    db = sqlite3.connect(":memory:")
    db.execute("PRAGMA foreign_keys = ON")
    db.executescript(read("01_schema.sql"))
    db.executescript(read("02_data.sql"))

    tables = [r[0] for r in db.execute(
        "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name")]
    total = sum(db.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0] for t in tables)
    broken = db.execute("PRAGMA foreign_key_check").fetchall()
    print(f"{len(tables)} tables, {total} rows, {len(broken)} broken foreign keys")
    if len(tables) != 21 or total != EXPECTED_ROWS or broken:
        sys.exit("Schema or data check failed.")

    queries = split_queries(read("03_queries.sql"))
    for title, sql in queries:
        print(f"\n{title}")
        cursor = db.execute(sql)
        show(cursor, cursor.fetchall())
    print(f"\nAll {len(queries)} queries ran.")


if __name__ == "__main__":
    main()
