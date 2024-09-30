-- You need not have two different tables to perform a join. Sometimes it is useful to join a table to itself, if you want to compare records in a table to other records in that same table. For example, to find breeding pairs among your pets, you can join the pet table with itself to produce candidate pairs of live males and females of like species: 

-- Esta versión es menos eficiente que la v1.

SELECT p1.name, p1.sex, p2.name, p2.sex, p1.species
FROM pet AS p1 INNER JOIN pet AS p2 ON p1.species = p2.species 
WHERE p1.sex = 'f' AND p1.death IS NULL AND p2.sex = 'm' AND p2.death IS NULL; 
