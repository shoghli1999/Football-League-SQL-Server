/*alter table bashgah
add constraint checkName
unique (bashgahName);*/

alter table modiramel
add constraint checkAge
check (age>8 and age<100);