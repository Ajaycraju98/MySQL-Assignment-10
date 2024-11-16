#1. Create a table named teachers with fields id, name, subject, experience and salary and insert 8 rows. 
create table teachers(teacher_id int primary key ,Name_of_the_teacher varchar(30) not null, subject varchar(30) not null,
experience int not null,salary int not null);
desc teachers;
insert into teachers(teacher_id,Name_of_the_teacher,subject,experience,salary) values (1,"ajay","English",2,45000),
(2,"arun","Maths",11,65000),(3,"fathima","Physics",3,40000),(4,"Farook","Chemistry",5,50000),(5,"Devanad","Social science",6,55000),
(6,"Janaki","Biology",7,55000),(7,"Neethu","IT",2,35000),(8,"Martin","Computer science",5,45000);
select * from teachers;

#2. Create a before insert trigger named before_insert_teacher that will raise an error 
“salary cannot be negative” if the salary inserted to the table is less than zero. 

DELIMITER $$ 
CREATE TRIGGER before_insert_teacher 
BEFORE INSERT ON teachers FOR EACH ROW 
BEGIN
if new.salary<0
then
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='salary cannot be negative';
end if;
END $$ 
DELIMITER ;
INSERT INTO teachers(teacher_id,Name_of_the_teacher,subject,experience,salary) VALUES (9,"Ram","Maths",2,-15000);
show triggers from entry_d41;

#3. Create an after insert trigger named after_insert_teacher that inserts a row with teacher_id,action
-- timestamp to a table called teacher_log when a new entry gets inserted to the teacher table. tecaher_id 
-- -> column of teacher table, action -> the trigger action, timestamp -> time at which the new row has got inserted. 

CREATE TABLE teacher_log (teacher_id INT primary key NOT NULL,action VARCHAR(50) NOT NULL,timestamp DATETIME NOT NULL);
select * from teacher_log;

DELIMITER $$ 
CREATE TRIGGER after_insert_teacher 
AFTER INSERT ON teachers FOR EACH ROW 
BEGIN
insert into teacher_log (teacher_id,action,timestamp) values (new.teacher_id,"insert data",now());
END $$ 
DELIMITER ;

INSERT INTO teachers(teacher_id,Name_of_the_teacher,subject,experience,salary) VALUES (10,"vipin","maths",3,35000);
select * from teachers;
select * from teacher_log;

#4. Create a before delete trigger that will raise an error when you try to delete a row that has experience greater than 10 years. 

DELIMITER $$ 
CREATE TRIGGER before_teacher_delete
before delete on teachers  for each row
begin
if old.experience>10
then
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='cannot delete teacher with more than  10 years of experience';
end if;
END $$ 
DELIMITER ;

delete from teachers where teacher_id=2;
select *  from teachers ;

#5. Create an after delete trigger that will insert a row to teacher_log table when that row is deleted from teacher table.
   
DELIMITER $$
CREATE TRIGGER after_delete_teacher AFTER DELETE  ON teachers  FOR EACH ROW 
BEGIN 
INSERT INTO teacher_log(teacher_id,action,timestamp) VALUES (OLD.teacher_id, 'AFTER DELETE',now()); 
END $$
DELIMITER ;

delete from teachers  where teacher_id=7;
select * from teacher_log;
