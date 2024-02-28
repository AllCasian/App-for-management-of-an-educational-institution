drop database if exists proiect;
create database proiect;

use proiect;
drop table if exists user;
create table user(
	id int auto_increment key,
    cnp varchar(15),
    nume varchar(15),
    prenume varchar(15),
    adresa varchar(100),
    nr_tel varchar(10),
    email varchar(50),
    iban varchar(30),
    nr_contract varchar(30),
    username varchar(50),
    parola varchar(50),
    idRol int
);
    
drop table if exists rol;
create table rol(
	id int auto_increment primary key,
    nume varchar(20)
);

alter table user add CONSTRAINT FK_id_user foreign key(idRol) references rol(id) on delete set null;

drop table if exists profesor;
create table profesor(
	id int,
    minOre int,
    maxOre int,
    idDepartament int
);

drop table if exists departament;
create table departament(
	id int auto_increment primary key,
    denumire varchar(20)
);

alter table profesor add foreign key(idDepartament) references departament(id) on delete set null;

alter table profesor add foreign key(id) references user(id);

drop table if exists student;
create table student(
	id int primary key,
    an_studiu int,
    ore_sustinute int
);

alter table student
add foreign key(id)
references user(id);

drop table if exists materie;
create table materie(
	id int auto_increment primary key,
    nume longtext,
    idDepartament int,
    idTitular int,
    curs double,
    seminar double,
    lab double
);

alter table materie
add foreign key(idDepartament)
references departament(id)
on delete set null;

alter table materie
add foreign key(idTitular)
references profesor(id)
on delete set null;

drop table if exists activitate_didactica;
create table activitate_didactica(
	id int auto_increment primary key,
    tip enum('curs', 'seminar', 'lab'),
    denumire varchar(30),
    data_incepere datetime,
    data_sfarsit datetime,
    nr_maxim int,
    durata_activitate int,
    idMaterie int
);

alter table activitate_didactica
add foreign key(idMaterie)
references materie(id)
on delete set null;

drop table if exists inscriere_student;
create table inscriere_student(
	idStudent int,
    idMaterie int,
    data_inscriere date,
    primary key(idStudent, idMaterie)
);

alter table inscriere_student
add foreign key (idStudent)
references student(id)
on delete cascade;

alter table inscriere_student
add foreign key (idMaterie)
references materie(id)
on delete cascade;

drop table if exists note;
create table note(
	idStudent int,
    idActDic int,
    valoare double,
    data_atribuire date,
    primary key(idStudent, idActDic)
);

alter table note
add foreign key(idStudent)
references student(id)
on delete cascade;

alter table note
add foreign key(idActDic)
references activitate_didactica(id)
on delete cascade;

drop table if exists didactic;
create table didactic(
	idProf int,
    idActDic int,
    data_asignarii date,
    primary key(idProf, idActDic)
);

alter table didactic
add foreign key (idProf)
references profesor(id)
on delete cascade;

alter table didactic
add foreign key (idActDic)
references activitate_didactica(id)
on delete cascade;

drop table if exists grup;
create table grup(
	id int auto_increment primary key,
    idMaterie int,
    idProf int,
    descriere text,
    denumire varchar(30)
);

alter table grup
add foreign key (idMaterie)
references materie(id)
on delete set null;

alter table grup
add foreign key(idProf)
references profesor(id)
on delete set null;

drop table if exists student_grupuri;
create table student_grupuri(
	idStudent int,
    idGrupa int,
    data_inscriere datetime,
    primary key(idStudent, idGrupa)
);

alter table student_grupuri
add foreign key (idStudent)
references student(id)
on delete cascade;

alter table student_grupuri
add foreign key (idGrupa)
references grup(id)
on delete cascade;

drop table if exists intalnire;
create table intalnire(
	id int auto_increment primary key,
    titlu varchar(30),
    nr_participanti int,
    durata int,
    data_incepere datetime,
    data_expirare datetime,
    idCreator int,
    idGrupa int
);

alter table intalnire
add foreign key (idCreator)
references student(id)
on delete set null;

alter table intalnire
add foreign key (idGrupa)
references grup(id)
on delete set null;

drop table if exists intalnire_student;
create table intalnire_studenti(
	idIntalnire int,
    idStudent int,
    data_inrolare date,
    primary key(idIntalnire, idStudent)
);

alter table intalnire_studenti
add foreign key(idIntalnire)
references intalnire(id)
on delete cascade;

alter table intalnire_studenti
add foreign key (idStudent)
references student(id)
on delete cascade;

drop table if exists mesaj_grup;
create table mesaj_grup(
	id int auto_increment primary key,
    idUser int,
    idGrup int, 
    mesaj text,
    data_trimitere datetime
);

alter table mesaj_grup
add foreign key (idUser)
references user(id)
on delete set null;

alter table mesaj_grup
add foreign key(idGrup)
references grup(id)
on delete set null;

drop table if exists mesaj_privat;
create table mesaj_privat(
	id int auto_increment primary key,
    idFrom int,
    idTo int,
    mesaj text,
    data_trimitere datetime
);

alter table mesaj_privat
add foreign key (idFrom)
references user(id)
on delete set null;

alter table mesaj_privat
add foreign key(idTo)
references user(id)
on delete set null;

drop table if exists examen;
create table examen(
	idMaterie int, 
    idStudent int,
    valoare double,
    primary key(idMaterie, idStudent)
);

alter table examen
add foreign key(idMaterie)
references materie(id)
on delete cascade;

alter table examen 
add foreign key (idStudent)
references student(id)
on delete cascade;

drop table if exists zi;
create table zi(
	id int auto_increment primary key,
    idUser int,
    idActivitate int,
    data_curenta datetime
);

alter table zi
add foreign key (idUser)
references user(id)
on delete set null;

alter table zi
add foreign key(idActivitate)
references activitate_didactica(id)
on delete set null;

drop trigger if exists t1;
delimiter //
CREATE TRIGGER initializare_profesor AFTER INSERT ON user
	FOR EACH ROW BEGIN
    if(new.idRol = 3) then
		INSERT INTO profesor (id) values (new.id);
	end if;
END; //

delimiter //
CREATE TRIGGER initializare_student AFTER INSERT ON user
	FOR EACH ROW BEGIN
    if(new.idRol = 4) then
		INSERT INTO student (id) values (new.id);
	end if;
END; //










