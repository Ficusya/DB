DROP SCHEMA IF EXISTS station CASCADE;

CREATE SCHEMA IF NOT EXISTS station
    AUTHORIZATION kulishkin_in;
	
COMMENT ON SCHEMA station
    IS 'Bus station';

GRANT ALL ON SCHEMA station TO kulishkin_in;

ALTER ROLE kulishkin_in IN DATABASE kulishkin_in_db
    SET search_path TO station, public;

drop table if exists Bus, Marks, Models, Employees, Positions, Bus_stop, Routes, Route_poins, Race, Passangers, RaceListf cascade;



CREATE TABLE  IF NOT EXISTS station.Bus (
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

COMMENT ON TABLE station.Bus IS 'Автобус';
COMMENT ON COLUMN station.Bus.ID IS 'Идентификатор автобуса';
COMMENT ON COLUMN station.Bus.Model_id IS 'Идентификатор модели автобуса';
COMMENT ON COLUMN station.Bus.Year IS 'Год выпуска автобуса';
COMMENT ON COLUMN station.Bus.reg_date IS 'Дата постановки на учет автобуса';
COMMENT ON COLUMN station.Bus.retire_date IS 'Дата списания автобуса';
COMMENT ON COLUMN station.Bus.last_service_date IS 'Дата прохождения последнего ТО автобуса';
COMMENT ON COLUMN station.Bus.gosnum IS 'Государственный номер автобуса';

INSERT INTO station.Bus (Model_id, Year, reg_date, retire_date, last_service_date, gosnum) VALUES
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

COMMENT ON TABLE station.Marks IS 'Марка автобуса';
COMMENT ON COLUMN station.Marks.ID IS 'Идентификатор марки автобуса';
COMMENT ON COLUMN station.Marks.MarkName IS 'Название марки автобуса';

INSERT INTO station.Marks (MarkName) VALUES
('Volvo'),
('Mercedes'),
('Iveco'),
('MAN'),
('Scania');



CREATE TABLE IF NOT EXISTS station.Models (
	ID serial NOT NULL,
	Mark_ID int NOT NULL,
	ModelName TEXT NOT NULL UNIQUE,
	FuelStorage int NOT NULL CHECK (FuelStorage > 0),
	Capacity int NOT NULL CHECK (Capacity > 0),
	CONSTRAINT Models_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE station.Models IS 'Модель автобуса';
COMMENT ON COLUMN station.Models.ID IS 'Уникальный идентификатор модели автобуса';
COMMENT ON COLUMN station.Models.Mark_ID IS 'Идентификатор марки автобуса';
COMMENT ON COLUMN station.Models.ModelName IS 'Название модели автобуса';
COMMENT ON COLUMN station.Models.FuelStorage IS 'Объем топливного бака автобуса';
COMMENT ON COLUMN station.Models.Capacity IS 'Вместимость автобуса';

INSERT INTO station.Models (Mark_ID, ModelName, FuelStorage, Capacity) VALUES
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

COMMENT ON TABLE station.Employees IS 'Сотрудник';
COMMENT ON COLUMN station.Employees.ID IS 'Уникальный идентификатор сотрудника';
COMMENT ON COLUMN station.Employees.first_name IS 'Имя сотрудника';
COMMENT ON COLUMN station.Employees.second_name IS 'Отчество сотрудника';
COMMENT ON COLUMN station.Employees.last_name IS 'Фамилия сотрудника';
COMMENT ON COLUMN station.Employees.birthdate IS 'Дата рождения сотрудника';
COMMENT ON COLUMN station.Employees.hire_date IS 'Дата найма сотрудника';
COMMENT ON COLUMN station.Employees.retire_date IS 'Дата увольнения сотрудника';
COMMENT ON COLUMN station.Employees.pos_id IS 'Идентификатор должности сотрудника';

INSERT INTO station.Employees (first_name, second_name, last_name, birthdate, hire_date, retire_date, pos_id) VALUES
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

COMMENT ON TABLE station.Positions IS 'Должность';
COMMENT ON COLUMN station.Positions.ID IS 'Уникальный идентификатор должности';
COMMENT ON COLUMN station.Positions.pos_name IS 'Название должности';

INSERT INTO station.Positions (pos_name) VALUES
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

COMMENT ON TABLE station.bus_stop IS 'Остановка';
COMMENT ON COLUMN station.bus_stop.ID IS 'Уникальный идентификатор остановки';
COMMENT ON COLUMN station.bus_stop.bs_name IS 'Название остановки';

INSERT INTO station.bus_stop (bs_name) VALUES
('Автовокзал'),
('Площадь Ленина'),
('Улица Гагарина'),
('Парк Победы'),
('ТЦ "Мега"'),
('Аэропорт');



CREATE TABLE station.routes (
	ID serial NOT NULL,
	route_name TEXT NOT NULL,
	start_point_id int NOT NULL,
	CONSTRAINT routes_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE station.routes IS 'Маршрут';
COMMENT ON COLUMN station.routes.ID IS 'Уникальный идентификатор маршрута';
COMMENT ON COLUMN station.routes.route_name IS 'Название маршрута';
COMMENT ON COLUMN station.routes.start_point_id IS 'Идентификатор начальной остановки маршрута';

INSERT INTO station.routes (route_name, start_point_id) VALUES
('Автовокзал - Аэропорт', 1),
('Аэропорт - Автовокзал', 6),
('Площадь Ленина - ТЦ "Мега"', 2),
('ТЦ "Мега" - Площадь Ленина', 5);



CREATE TABLE station.route_points (
	ID serial,
	route_id int NOT NULL,
	bus_stop_id int NOT NULL,
	next_point_id int NOT NULL,
	CONSTRAINT route_points_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE station.route_points IS 'Точка маршрута';
COMMENT ON COLUMN station.route_points.ID IS 'Уникальный идентификатор точки маршрута';
COMMENT ON COLUMN station.route_points.route_id IS 'Идентификатор маршрута';
COMMENT ON COLUMN station.route_points.bus_stop_id IS 'Идентификатор остановки';
COMMENT ON COLUMN station.route_points.next_point_id IS 'Идентификатор следующей точки маршрута';

INSERT INTO station.route_points (route_id, bus_stop_id, next_point_id) VALUES
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



CREATE TABLE station.Race (
	ID serial NOT NULL,
	start_date TEXT NOT NULL,
	finish_date TEXT NOT NULL,
	duration TEXT NOT NULL,
	route_id int NOT NULL,
	bus_id int NOT NULL,
	driver_id int NOT NULL,
	CONSTRAINT Race_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE station.Race IS 'Рейс';
COMMENT ON COLUMN station.Race.ID IS 'Уникальный идентификатор рейса';
COMMENT ON COLUMN station.Race.start_date IS 'Дата и время начала рейса';
COMMENT ON COLUMN station.Race.finish_date IS 'Дата и время окончания рейса';
COMMENT ON COLUMN station.Race.duration IS 'Продолжительность рейса';
COMMENT ON COLUMN station.Race.route_id IS 'Идентификатор маршрута';
COMMENT ON COLUMN station.Race.bus_id IS 'Идентификатор автобуса';
COMMENT ON COLUMN station.Race.driver_id IS 'Идентификатор водителя';

INSERT INTO station.Race (start_date, finish_date, duration, route_id, bus_id, driver_id) VALUES
('2023-12-01 08:00:00', '2023-12-01 09:30:00', '01:30:00', 1, 1, 1),
('2023-12-01 10:00:00', '2023-12-01 11:30:00', '01:30:00', 2, 1, 1),
('2023-12-01 12:00:00', '2023-12-01 13:00:00', '01:00:00', 3, 2, 2),
('2023-12-01 14:00:00', '2023-12-01 15:00:00', '01:00:00', 4, 2, 2),
('2023-12-01 16:00:00', '2023-12-01 17:30:00', '01:30:00', 1, 3, 3),
('2023-12-01 18:00:00', '2023-12-01 19:30:00', '01:30:00', 2, 3, 3),
('2023-12-01 20:00:00', '2023-12-01 21:00:00', '01:00:00', 3, 4, 4),
('2023-12-01 22:00:00', '2023-12-01 23:00:00', '01:00:00', 4, 4, 4);



CREATE TABLE station.Passangers (
	ID serial NOT NULL,
	first_name TEXT NOT NULL,
	second_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	birthdate DATE NOT NULL,
	doc_type int NOT NULL,
	doc_series int NOT NULL,
	doc_num int NOT NULL,
	sex TEXT NOT NULL,
	phone_num TEXT NOT NULL,
	CONSTRAINT Passangers_pk PRIMARY KEY (ID)
) WITH (
  OIDS=FALSE
);

COMMENT ON TABLE station.Passangers IS 'Пассажиры';
COMMENT ON COLUMN station.Passangers.ID IS 'Уникальный идентификатор пассажира';
COMMENT ON COLUMN station.Passangers.first_name IS 'Имя пассажира';
COMMENT ON COLUMN station.Passangers.second_name IS 'Отчество пассажира';
COMMENT ON COLUMN station.Passangers.last_name IS 'Фамилия пассажира';
COMMENT ON COLUMN station.Passangers.birthdate IS 'Дата рождения пассажира';
COMMENT ON COLUMN station.Passangers.doc_type IS 'Тип документа пассажира';
COMMENT ON COLUMN station.Passangers.doc_series IS 'Серия документа пассажира';
COMMENT ON COLUMN station.Passangers.doc_num IS 'Номер документа пассажира';
COMMENT ON COLUMN station.Passangers.sex IS 'Пол пассажира';
COMMENT ON COLUMN station.Passangers.phone_num IS 'Номер телефона пассажира';

INSERT INTO station.Passangers (first_name, second_name, last_name, birthdate, doc_type, doc_series, doc_num, sex, phone_num) VALUES
('Иван', 'Иванович', 'Иванов', '1990-01-01', 1, 1111, 111111, 'М', '1111111111'),
('Петр', 'Петрович', 'Петров', '1991-02-02', 1, 2222, 222222, 'М', '2222222222'),
('Анна', 'Андреевна', 'Андреева', '1992-03-03', 1, 3333, 333333, 'Ж', '3333333333'),
('Мария', 'Михайловна', 'Михайлова', '1993-04-04', 1, 4444, 444444, 'Ж', '4444444444'),
('Сергей', 'Сергеевич', 'Сергеев', '1994-05-05', 1, 5555, 555555, 'М', '5555555555'),
('Елена', 'Евгеньевна', 'Евгеньева', '1995-06-06', 1, 6666, 666666, 'Ж', '6666666666'),
('Дмитрий', 'Дмитриевич', 'Дмитриев', '1996-07-07', 1, 7777, 777777, 'М', '7777777777');



CREATE TABLE station.RaceList (
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

COMMENT ON TABLE station.RaceList IS 'Список рейсов';
COMMENT ON COLUMN station.RaceList.ID IS 'Уникальный идентификатор записи в списке рейсов';
COMMENT ON COLUMN station.RaceList.race_id IS 'Идентификатор рейса';
COMMENT ON COLUMN station.RaceList.passanger_id IS 'Идентификатор пассажира';
COMMENT ON COLUMN station.RaceList.seat_num IS 'Номер места';
COMMENT ON COLUMN station.RaceList.route_start IS 'Идентификатор начальной точки маршрута';
COMMENT ON COLUMN station.RaceList.route_finish IS 'Идентификатор конечной точки маршрута';



ALTER TABLE station.Bus ADD CONSTRAINT Bus_fk_Model_id FOREIGN KEY (Model_id) REFERENCES station.Models(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE station.Models ADD CONSTRAINT Models_fk_Mark_ID FOREIGN KEY (Mark_ID) REFERENCES station.Marks(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE station.Employees ADD CONSTRAINT Employees_fk_pos_id FOREIGN KEY (pos_id) REFERENCES station.Positions(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE station.routes ADD CONSTRAINT routes_fk_start_point_id FOREIGN KEY (start_point_id) REFERENCES station.route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE station.route_points ADD CONSTRAINT route_points_fk_route_id FOREIGN KEY (route_id) REFERENCES station.routes(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE station.route_points ADD CONSTRAINT route_points_fk_bus_stop_id FOREIGN KEY (bus_stop_id) REFERENCES station.bus_stop(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE station.route_points ADD CONSTRAINT route_points_fk_next_point_id FOREIGN KEY (next_point_id) REFERENCES station.route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE station.Race ADD CONSTRAINT Race_fk_route_id FOREIGN KEY (route_id) REFERENCES station.routes(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE station.Race ADD CONSTRAINT Race_fk_bus_id FOREIGN KEY (bus_id) REFERENCES station.Bus(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE station.Race ADD CONSTRAINT Race_fk_driver_id FOREIGN KEY (driver_id) REFERENCES station.Employees(ID) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE station.RaceList ADD CONSTRAINT RaceList_fk_race_id FOREIGN KEY (race_id) REFERENCES station.Race(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE station.RaceList ADD CONSTRAINT RaceList_fk_passanger_id FOREIGN KEY (passanger_id) REFERENCES station.Passangers(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE station.RaceList ADD CONSTRAINT RaceList_fk_route_start FOREIGN KEY (route_start) REFERENCES station.route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE station.RaceList ADD CONSTRAINT RaceList_fk_route_finish FOREIGN KEY (route_finish) REFERENCES station.route_points(ID) ON UPDATE CASCADE ON DELETE RESTRICT;


CREATE OR REPLACE VIEW high_earners AS
SELECT e.first_name || ' ' || e.last_name AS name, e.Salary, d.Name AS department
FROM station.Employees e
JOIN station.Department d ON e.DeptID = d.ID
WHERE e.Salary > (SELECT AVG(Salary) FROM station.Employees WHERE DeptID = e.DeptID);

CREATE OR REPLACE VIEW race_stats AS
SELECT r.ID, r.route_id, t.route_name, COUNT(p.ID) AS total_passengers, ROUND(COUNT(p.ID) * 100.0 / b.Capacity, 2) AS avg_occupancy
FROM station.Race r
JOIN station.RaceList l ON r.ID = l.race_id
JOIN station.Passangers p ON l.passanger_id = p.ID
JOIN station.routes t ON r.route_id = t.ID
JOIN station.Bus b ON r.bus_id = b.ID
GROUP BY r.ID, r.route_id, t.route_name, b.Capacity;

CREATE OR REPLACE VIEW passenger_info AS
SELECT p.first_name || ' ' || p.last_name AS name, DATE_PART('year', CURRENT_DATE) - DATE_PART('year', p.birthdate) AS age, p.sex, r.route_id, t.route_name, r.start_date
FROM station.Passangers p
JOIN station.RaceList l ON p.ID = l.passanger_id
JOIN station.Race r ON l.race_id = r.ID
JOIN station.routes t ON r.route_id = t.ID
WHERE r.start_date = '2023-12-01 08:00:00' AND t.route_name = 'Автовокзал - Аэропорт';


CREATE OR REPLACE FUNCTION update_last_service_date() RETURNS TRIGGER AS $$
BEGIN
  UPDATE station.Bus b
  SET last_service_date = NEW.finish_date
  WHERE b.id = NEW.bus_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_last_service_date
AFTER UPDATE ON station.Race
FOR EACH ROW
EXECUTE FUNCTION update_last_service_date();
