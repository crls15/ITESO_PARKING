
--- Query para saber si el usuario ya se encuentra estacionado
SELECT parking_logs.id_parking_logs
FROM users
INNER JOIN parking_logs
ON parking_logs.id_users = users.id_users
WHERE parking_logs.isActive = 1
AND users.firebase_id = "XXX"

--- Query para asignar un lugar favorito
SELECT
    user_favorite_sections.id_sections,
    user_favorite_sections.score,
    sections.sectionName,
    places.placeNumber
FROM user_favorite_sections
INNER JOIN users ON users.id_users = user_favorite_sections.id_users
INNER JOIN sections ON sections.id_sections = user_favorite_sections.id_sections
INNER JOIN places ON places.id_sections = sections.id_sections
WHERE users.id_users = # -- Cambiar por el ID del usuario deseado
    AND places.isOccupied = 0
ORDER BY sections.sectionName ASC, places.placeNumber ASC
LIMIT 1;

--Query para asignar un lugar cualquiera
SELECT 
    sections.sectionName,
    places.placeNumber
FROM places
INNER JOIN sections
ON sections.id_sections = places.id_sections
WHERE places.isOccupied = 0
ORDER BY sections.sectionName ASC, places.placeNumber ASC
LIMIT 1

---Query para cuando se asigna un lugar a un usuario

INSERT INTO parking_logs (id_users, id_user_cars, id_places, checkIn, isActive)
VALUES (1, 1, 1, NOW(), 1);

UPDATE places
SET isOccupied = 1,
    id_users_occupiedBy = 1,
    isAutoAssigned = 1
WHERE id_places = 1;

--Query para indicar la salida del usuario
SELECT id_places
FROM parking_logs 
WHERE id_users = <id del usuario> AND isActive = 1;

UPDATE parking_logs
SET isParked = 0,
    checkOut = NOW(),
    isActive = 0
WHERE id_users = <id del usuario> AND isActive = 1;

UPDATE places
SET isOccupied = 0, 
id_users_occupiedBy = NULL,
isAutoAssigned = NULL
WHERE id_places = {id_del_lugar_ocupado};

---Query para obtener la informacion de los autos del usuario
SELECT * 
FROM user_cars
INNER JOIN users
ON users.id_users = user_cars.id_users
WHERE users.firebase_id = ${firebase_id}