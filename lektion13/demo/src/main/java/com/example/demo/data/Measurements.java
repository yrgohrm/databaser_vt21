package com.example.demo.data;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection="measurements")
@Data
@NoArgsConstructor
public class Measurements {
    private String id;
    private ObjectId sensorId;
    
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private Instant startTime;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private Instant endTime;

    private List<Measurement> values = new ArrayList<>();
}
