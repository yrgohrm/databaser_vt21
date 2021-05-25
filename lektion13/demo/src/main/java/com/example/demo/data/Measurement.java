package com.example.demo.data;

import java.time.Instant;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Measurement {
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private Instant time;
    private Double value;
    private String unit;
}
