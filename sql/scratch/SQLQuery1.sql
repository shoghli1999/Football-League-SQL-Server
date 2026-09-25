create table tarkibavaliye( 
tarkibAvaliyeId int primary key,
gameId int foreign key references game(gameId),
bazikonId bigint foreign key references bazikon(codeMelli),
mogheiyat varchar(50),
);