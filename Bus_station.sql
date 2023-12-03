DROP SCHEMA IF EXISTS station ;

CREATE SCHEMA IF NOT EXISTS station
    AUTHORIZATION kulishkin_in;
	
COMMENT ON SCHEMA station
    IS 'Bus station';

GRANT ALL ON SCHEMA station TO kulishkin_in;

ALTER ROLE kulishkin_in IN DATABASE kulishkin_in_db
    SET search_path TO station, public;

drop table if exists bus, marks, models, employees, positions, bus_stop cascade;

CREATE TABLE IF NOT EXISTS station.Bus (
	ID serial NOT NULL,
	Model_id int NOT NULL,
	Year int NOT NULL CHECK (Year > 1980),
	reg_date TIMESTAMP NOT NULL,
	retire_date TIMESTAMP NOT NULL,
	last_service_date TIMESTAMP NOT NULL,
	gosnum TEXT NOT NULL UNIQUE,
	CONSTRAINT Bus_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE Bus IS 'Автобус';
COMMENT ON COLUMN Bus.ID IS 'Идентификатор автобуса';
COMMENT ON COLUMN Bus.Model_id IS 'Идентификатор модели автобуса';
COMMENT ON COLUMN Bus.Year IS 'Год выпуска автобуса';
COMMENT ON COLUMN Bus.reg_date IS 'Дата постановки на учет автобуса';
COMMENT ON COLUMN Bus.retire_date IS 'Дата списания автобуса';
COMMENT ON COLUMN Bus.last_service_date IS 'Дата прохождения последнего ТО автобуса';
COMMENT ON COLUMN Bus.gosnum IS 'Государственный номер автобуса';

INSERT INTO Bus (Model_id, Year, reg_date, retire_date, last_service_date, gosnum) VALUES
(1, 2010, '2010-01-01', '2020-12-31', '2020-11-30', 'A001AA'),
(2, 2015, '2015-05-05', '2025-05-04', '2020-10-10', 'B002BB'),
(3, 2018, '2018-08-08', '2028-08-07', '2020-09-09', 'C003CC'),
(4, 2020, '2020-02-02', '2030-02-01', '2020-08-08', 'D004DD'),
(5, 2021, '2021-03-03', '2031-03-02', '2021-04-04', 'E005EE');

CREATE TABLE IF NOT EXISTS station.Marks (
	ID serial NOT NULL,
	MarkName TEXT NOT NULL UNIQUE,
	CONSTRAINT Marks_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE Marks IS 'Марка автобуса';
COMMENT ON COLUMN Marks.ID IS 'Идентификатор марки автобуса';
COMMENT ON COLUMN Marks.MarkName IS 'Название марки автобуса';

INSERT INTO Marks (MarkName) VALUES
('Volvo'),
('Mercedes'),
('Iveco'),
('MAN'),
('Scania');

CREATE TABLE IF NOT EXISTS station.Models (
	ID serial NOT NULL,
	Mark_ID int NOT NULL,
	ModelName serial NOT NULL UNIQUE,
	FuelStorage int NOT NULL CHECK (FuelStorage > 0),
	Capacity int NOT NULL CHECK (Capacity > 0),
	CONSTRAINT Models_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE Models IS 'Модель автобуса';
COMMENT ON COLUMN Models.ID IS 'Уникальный идентификатор модели автобуса';
COMMENT ON COLUMN Models.Mark_ID IS 'Идентификатор марки автобуса';
COMMENT ON COLUMN Models.ModelName IS 'Название модели автобуса';
COMMENT ON COLUMN Models.FuelStorage IS 'Объем топливного бака автобуса';
COMMENT ON COLUMN Models.Capacity IS 'Вместимость автобуса';

INSERT INTO Models (Mark_ID, ModelName, FuelStorage, Capacity) VALUES
(1, 'Volvo 9700', 500, 50),
(2, 'Mercedes-Benz Tourismo', 450, 48),
(3, 'Iveco Magelys', 400, 46),
(4, 'MAN Lions Coach', 550, 52),
(5, 'Scania Touring', 600, 54);

CREATE TABLE IF NOT EXISTS station.Employees (
	ID serial NOT NULL,
	first_name TEXT NOT NULL,
	second_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	birthdate DATE NOT NULL,
	hire_date DATE NOT NULL,
	retire_date DATE NOT NULL,
	pos_id int NOT NULL,
	CONSTRAINT Employees_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE Employees IS 'Сотрудник';
COMMENT ON COLUMN Employees.ID IS 'Уникальный идентификатор сотрудника';
COMMENT ON COLUMN Employees.first_name IS 'Имя сотрудника';
COMMENT ON COLUMN Employees.second_name IS 'Отчество сотрудника';
COMMENT ON COLUMN Employees.last_name IS 'Фамилия сотрудника';
COMMENT ON COLUMN Employees.birthdate IS 'Дата рождения сотрудника';
COMMENT ON COLUMN Employees.hire_date IS 'Дата найма сотрудника';
COMMENT ON COLUMN Employees.retire_date IS 'Дата увольнения сотрудника';
COMMENT ON COLUMN Employees.pos_id IS 'Идентификатор должности сотрудника';

INSERT INTO Employees (first_name, second_name, last_name, birthdate, hire_date, retire_date, pos_id) VALUES
('Иван', 'Иванович', 'Иванов', '1980-01-01', '2010-01-01', '2030-01-01', 1),
('Петр', 'Петрович', 'Петров', '1981-02-02', '2011-02-02', '2031-02-02', 2),
('Сергей', 'Сергеевич', 'Сергеев', '1982-03-03', '2012-03-03', '2032-03-03', 3),
('Анна', 'Андреевна', 'Андреева', '1983-04-04', '2013-04-04', '2033-04-04', 4),
('Мария', 'Михайловна', 'Михайлова', '1984-05-05', '2014-05-05', '2034-05-05', 5);

CREATE TABLE IF NOT EXISTS station.Positions (
	ID serial NOT NULL,
	pos_name TEXT NOT NULL UNIQUE,
	CONSTRAINT Positions_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE Positions IS 'Должность';
COMMENT ON COLUMN Positions.ID IS 'Уникальный идентификатор должности';
COMMENT ON COLUMN Positions.pos_name IS 'Название должности';

INSERT INTO Positions (pos_name) VALUES
('Директор'),
('Заместитель директора'),
('Бухгалтер'),
('Менеджер'),
('Водитель');

CREATE TABLE IF NOT EXISTS station.bus_stop (
	ID serial NOT NULL,
	bs_name TEXT NOT NULL UNIQUE,
	CONSTRAINT bus_stop_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE bus_stop IS 'Остановка';
COMMENT ON COLUMN bus_stop.ID IS 'Уникальный идентификатор остановки';
COMMENT ON COLUMN bus_stop.bs_name IS 'Название остановки';

CREATE TABLE routes (
	ID serial NOT NULL,
	route_name TEXT NOT NULL,
	start_point_id int NOT NULL,
	CONSTRAINT routes_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);	

COMMENT ON TABLE routes IS 'Маршрут';
COMMENT ON COLUMN routes.ID IS 'Уникальный идентификатор маршрута';
COMMENT ON COLUMN routes.route_name IS 'Название маршрута';
COMMENT ON COLUMN routes.start_point_id IS 'Идентификатор начальной остановки маршрута';

CREATE TABLE route_points (
	ID serial,
	route_id int NOT NULL,
	bus_stop_id int NOT NULL,
	next_point_id int NOT NULL,
	CONSTRAINT route_points_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE route_points IS 'Точка маршрута';
COMMENT ON COLUMN route_points.ID IS 'Уникальный идентификатор точки маршрута';
COMMENT ON COLUMN route_points.route_id IS 'Идентификатор маршрута';
COMMENT ON COLUMN route_points.bus_stop_id IS 'Идентификатор остановки';
COMMENT ON COLUMN route_points.next_point_id IS 'Идентификатор следующей точки маршрута';

CREATE TABLE Race (
	ID serial NOT NULL,
	start_date serial NOT NULL,
	finish_date serial NOT NULL,
	duration serial NOT NULL,
	route_id int NOT NULL,
	bus_id int NOT NULL,
	driver_id int NOT NULL,
	CONSTRAINT Race_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE Race IS 'Рейс';
COMMENT ON COLUMN Race.ID IS 'Уникальный идентификатор рейса';
COMMENT ON COLUMN Race.start_date IS 'Дата и время начала рейса';
COMMENT ON COLUMN Race.finish_date IS 'Дата и время окончания рейса';
COMMENT ON COLUMN Race.duration IS 'Продолжительность рейса';
COMMENT ON COLUMN Race.route_id IS 'Идентификатор маршрута';
COMMENT ON COLUMN Race.bus_id IS 'Идентификатор автобуса';
COMMENT ON COLUMN Race.driver_id IS 'Идентификатор водителя';

CREATE TABLE Passangers (
	ID serial NOT NULL,
	first_name TEXT NOT NULL,
	second_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	birthdate DATE NOT NULL,
	doc_type int NOT NULL,
	doc_series int NOT NULL,
	doc_num int NOT NULL,
	sex TEXT NOT NULL,
	phone_num int NOT NULL,
	CONSTRAINT Passangers_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE Passangers IS 'Пассажиры';
COMMENT ON COLUMN Passangers.ID IS 'Уникальный идентификатор пассажира';
COMMENT ON COLUMN Passangers.first_name IS 'Имя пассажира';
COMMENT ON COLUMN Passangers.second_name IS 'Отчество пассажира';
COMMENT ON COLUMN Passangers.last_name IS 'Фамилия пассажира';
COMMENT ON COLUMN Passangers.birthdate IS 'Дата рождения пассажира';
COMMENT ON COLUMN Passangers.doc_type IS 'Тип документа пассажира';
COMMENT ON COLUMN Passangers.doc_series IS 'Серия документа пассажира';
COMMENT ON COLUMN Passangers.doc_num IS 'Номер документа пассажира';
COMMENT ON COLUMN Passangers.sex IS 'Пол пассажира';
COMMENT ON COLUMN Passangers.phone_num IS 'Номер телефона пассажира';

CREATE TABLE RaceList (
	ID serial NOT NULL,
	race_id int NOT NULL,
	passanger_id int NOT NULL,
	seat_num int NOT NULL,
	route_start int NOT NULL,
	route_finish int NOT NULL,
	CONSTRAINT RaceList_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE RaceList IS 'Список рейсов';
COMMENT ON COLUMN RaceList.ID IS 'Уникальный идентификатор записи в списке рейсов';
COMMENT ON COLUMN RaceList.race_id IS 'Идентификатор рейса';
COMMENT ON COLUMN RaceList.passanger_id IS 'Идентификатор пассажира';
COMMENT ON COLUMN RaceList.seat_num IS 'Номер места';
COMMENT ON COLUMN RaceList.route_start IS 'Идентификатор начальной точки маршрута';
COMMENT ON COLUMN RaceList.route_finish IS 'Идентификатор конечной точки маршрута';

INSERT INTO bus_stop (bs_name) VALUES
('Автовокзал'),
('Площадь Ленина'),
('Улица Гагарина'),
('Парк Победы'),
('ТЦ "Мега"'),
('Аэропорт');

INSERT INTO routes (route_name, start_point_id) VALUES
('Автовокзал - Аэропорт', 1),
('Аэропорт - Автовокзал', 6),
('Площадь Ленина - ТЦ "Мега"', 2),
('ТЦ "Мега" - Площадь Ленина', 5);

INSERT INTO route_points (route_id, bus_stop_id, next_point_id) VALUES
(1, 1, 2),
(1, 2, 3),
(1, 3, 4),
(1, 4, 5),
(1, 5, 6),
(2, 6, 5),
(2, 5, 4),
(2, 4, 3),
(2, 3, 2),
(2, 2, 1),
(3, 2, 3),
(3, 3, 4),
(3, 4, 5),
(4, 5, 4),
(4, 4, 3),
(4, 3, 2);

INSERT INTO Race (start_date, finish_date, duration, route_id, bus_id, driver_id) VALUES
('2023-12-01 08:00:00', '2023-12-01 09:30:00', '01:30:00', 1, 1, 1),
('2023-12-01 10:00:00', '2023-12-01 11:30:00', '01:30:00', 2, 1, 1),
('2023-12-01 12:00:00', '2023-12-01 13:00:00', '01:00:00', 3, 2, 2),
('2023-12-01 14:00:00', '2023-12-01 15:00:00', '01:00:00', 4, 2, 2),
('2023-12-01 16:00:00', '2023-12-01 17:30:00', '01:30:00', 1, 3, 3),
('2023-12-01 18:00:00', '2023-12-01 19:30:00', '01:30:00', 2, 3, 3),
('2023-12-01 20:00:00', '2023-12-01 21:00:00', '01:00:00', 3, 4, 4),
('2023-12-01 22:00:00', '2023-12-01 23:00:00', '01:00:00', 4, 4, 4);

INSERT INTO Passangers (first_name, second_name, last_name, birthdate, doc_type, doc_series, doc_num, sex, phone_num) VALUES
('Иван', 'Иванович', 'Иванов', '1990-01-01', 1, 1111, 111111, 'М', 1111111111),
('Петр', 'Петрович', 'Петров', '1991-02-02', 1, 2222, 222222, 'М', 2222222222),
('Анна', 'Андреевна', 'Андреева', '1992-03-03', 1, 3333, 333333, 'Ж', 3333333333),
('Мария', 'Михайловна', 'Михайлова', '1993-04-04', 1, 4444, 444444, 'Ж', 4444444444),
('Сергей', 'Сергеевич', 'Сергеев', '1994-05-05', 1, 5555, 555555, 'М', 5555555555),
('Елена', 'Евгеньевна', 'Евгеньева', '1995-06-06', 1, 6666, 666666, 'Ж', 6666666666),
('Дмитрий', 'Дмитриевич', 'Дмитриев', '1996-07-07', 1, 7777, 777777, 'М', 7777777777);

ALTER TABLE Bus ADD CONSTRAINT Bus_fk0 FOREIGN KEY (Model_id) REFERENCES Models(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Models ADD CONSTRAINT Models_fk_Mark_ID FOREIGN KEY (Mark_ID) REFERENCES Marks(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Employees ADD CONSTRAINT Employees_fk_pos_id FOREIGN KEY (pos_id) REFERENCES Positions(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE routes ADD CONSTRAINT routes_fk_start_point_id FOREIGN KEY (start_point_id) REFERENCES route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE route_points ADD CONSTRAINT route_points_fk_route_id FOREIGN KEY (route_id) REFERENCES routes(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE route_points ADD CONSTRAINT route_points_fk_bus_stop_id FOREIGN KEY (bus_stop_id) REFERENCES bus_stop(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE route_points ADD CONSTRAINT route_points_fk_next_point_id FOREIGN KEY (next_point_id) REFERENCES route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Race ADD CONSTRAINT Race_fk_route_id FOREIGN KEY (route_id) REFERENCES routes(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE Race ADD CONSTRAINT Race_fk_bus_id FOREIGN KEY (bus_id) REFERENCES Bus(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE Race ADD CONSTRAINT Race_fk_driver_id FOREIGN KEY (driver_id) REFERENCES Employees(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE RaceList ADD CONSTRAINT RaceList_fk_race_id FOREIGN KEY (race_id) REFERENCES Race(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE RaceList ADD CONSTRAINT RaceList_fk_passanger_id FOREIGN KEY (passanger_id) REFERENCES Passangers(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE RaceList ADD CONSTRAINT RaceList_fk_route_start FOREIGN KEY (route_start) REFERENCES route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE RaceList ADD CONSTRAINT RaceList_fk_route_finish FOREIGN KEY (route_finish) REFERENCES route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
