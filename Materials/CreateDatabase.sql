drop database if exists Email_Database;

create database Email_Database;

use Email_Database;

create table User(
	id int not null unique, 
	UserName varchar(64) not null unique, 
	Password varchar(128) not null, 
	Type enum('NORMAL', 'ADMIN', 'SUPER') not null, 
	primary key(id));

create table Recovery_Contact( 
	Contact varchar(254) not null unique, 
	UserID int not null,
	primary key(Contact), 
	foreign key(UserID) references User(id));

create table Activity(
	id int not null unique, 
	UserID int not null, 
	Activity varchar(64) not null, 
	Time TimeStamp not null,
	primary key(id), 
	foreign key(UserID) references User(id));
    
create table Contact(
	id varchar(254) not null unique,
	primary key(id));

create table Flag(
	UserID int not null,
	ContactId varchar(254) not null unique,
	Type enum('PROVIDED_EMAIL_TO_THIRD_PARTY', 'SPAMMING', 'MALICIOUS', 'ANNOYING') not null, 
	Comment text not null,
	Time TimeStamp not null,
	primary key(UserID, ContactId), 
	foreign key(UserID) references User(id),
    foreign key(ContactId) references Contact(id));

create table User_Contact(
	ConnectingEmail varchar(254) not null unique, 
	UserID int not null,
	ContactAlias text not null,
	ContactId varchar(254) not null,
	isFollowed boolean not null default true,
	primary key(ConnectingEmail), 
	foreign key(UserID) references User(id),
	foreign key(ContactId) references Contact(id));

create table Contact_Address(
	ConnectingEmail varchar(254) not null, 
	ContactAddress varchar(254) not null, 
	primary key(ConnectingEmail, ContactAddress), 
	foreign key(ConnectingEmail) references User_Contact(ConnectingEmail));

create table URL(
	id int not null unique,
	url varchar(2083) unique,
	ContactId varchar(254) not null,
	primary key(id), 
	foreign key(ContactId) references Contact(id));	

create table Email(
	id int not null unique, 
	Subject varchar(256) not null,
	Body text not null,
	OutgoingEmail varchar(254) not null,
	IncomingAddresses varchar(254) not null,
	Time TimeStamp not null,
	primary key(id),
	foreign key(OutgoingEmail) references User_Contact(ConnectingEmail),
	foreign key(IncomingAddresses) references User_Contact(ConnectingEmail)); 

create table IncomingAddresses(
	EmailID int not null, 
	Address varchar(254) not null,
	primary key(EmailID, Address), 
	foreign key(EmailID) references Email(id));

create table CCAddress(
	EmailID int not null , 
	Address varchar(254) not null,
	primary key(EmailID, Address), 
	foreign key(EmailID) references Email(id));

create table BCCAddress(
	EmailID int not null , 
	Address varchar(254) not null,
	primary key(EmailID, Address), 
	foreign key(EmailID) references Email(id));
