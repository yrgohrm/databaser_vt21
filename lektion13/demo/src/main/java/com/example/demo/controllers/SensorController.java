package com.example.demo.controllers;

import java.util.List;

import com.example.demo.data.Sensor;
import com.example.demo.repositories.SensorRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "sensors",
                produces = MediaType.APPLICATION_JSON_VALUE)
public class SensorController {
    @Autowired
    private SensorRepository sensors;

    @GetMapping
    public List<Sensor> getAllSensors() {
        return sensors.findAll();
    }

    @PostMapping
    public Sensor newSensor(@RequestBody Sensor sensor) {
        return sensors.insert(sensor);
    }

    @GetMapping("/{type}")
    public List<Sensor> getSensorsFromType(@PathVariable String type) {
        return sensors.findByType(type);
    }
}
