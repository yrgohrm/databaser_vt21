package com.example.demo.data;

import java.time.LocalDate;

import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection="sensors")
@Data
@NoArgsConstructor
public class Sensor {
    private String id;
    private String serial;
    private String type;
    private LocalDate calibrationDate;   
}
