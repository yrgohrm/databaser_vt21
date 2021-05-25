package com.example.demo.repositories;

import java.util.List;

import com.example.demo.data.Sensor;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface SensorRepository extends MongoRepository<Sensor, String> {
    List<Sensor> findByType(String type);
}
