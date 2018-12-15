use internetbanken;

CALL createAccountHolder('Erik', 1392, '1992-01-16', 'Minvervavägen 20', 'Karlskrona');
CALL createAccountHolder('Simon', 4566, '1992-08-20', 'Visbyvägen 1', 'Visby');
CALL createAccountHolder('Jacob', 3645, '1992-08-16', 'Borlängegatan 7 ', 'Borlänge');
CALL createAccountHolder('Anton', 6737, '1992-02-16', 'Skräddarbacksvägen 7', 'Borlänge');
CALL createAccountHolder('Terje', 2352, '1969-05-16', 'Falugatan 20', 'Falun');
CALL createAccountHolder('Jonas', 7574, '1992-10-16', 'Kviddas väg 9', 'Borlänge');
CALL createAccountHolder('Philip', 3452, '1992-09-16', 'Göteborgsgatan 101', 'Göteborg');
CALL createAccountHolder('Maxopling', 5555, '1992-01-16', 'Minvervavägen 23', 'Karlskrona');
CALL createAccountHolder('Steffe', 4656, '1960-01-16', 'Drottninggatan 100', 'Stockholm');
CALL createAccountHolder('Gudrun', 8764, '1920-01-16', 'Terjes palats 3', 'Stockholm');
CALL createAccountHolder('Vladimir', 3757, '1952-10-07', 'Leningrad Street', 'Moskva');
CALL createAccountHolder('Donald', 2722, '1946-06-14', '1600 Pennsylvania Ave', 'Washington DC');
CALL createAccountHolder('Milo', 2222, '1984-10-18', 'Dangerous Street 5', 'Miami');
CALL createAccountHolder('Janomack', 3453, '1970-008-16', 'Minvervavägen 22', 'Karlskrona');
select * from accountHolder;
select * from accountHolder;
CALL createAccount(1201);
CALL createAccount(3453);
CALL createAccount(64646);
CALL createAccount(34532);
CALL createAccount(100450);
CALL createAccount(345345);
CALL createAccount(345);
CALL createAccount(43535);
CALL createAccount(456456);
CALL createAccount(456);
CALL createAccount(444);
CALL createAccount(345363534);
CALL createAccount(109019209);
CALL createAccount(31967383);
CALL createAccount(9945);
select * from account;

CALL connectAccount(1000, 100000);
CALL connectAccount(1001, 100001);
CALL connectAccount(1001, 100002);
CALL connectAccount(1001, 100003);
CALL connectAccount(1002, 100001);
CALL connectAccount(1002, 100002);
CALL connectAccount(1002, 100003);
CALL connectAccount(1003, 100001);
CALL connectAccount(1003, 100002);
CALL connectAccount(1003, 100003);
CALL connectAccount(1004, 100004);
CALL connectAccount(1005, 100005);
CALL connectAccount(1006, 100006);
CALL connectAccount(1007, 100007);
CALL connectAccount(1008, 100008);
CALL connectAccount(1009, 100009);
CALL connectAccount(1010, 100010);
CALL connectAccount(1011, 100011);
CALL connectAccount(1012, 100012);
CALL connectAccount(1013, 100013);

select * from AccountHolder_Account;

select * from log;
show tables;


