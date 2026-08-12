package com.backend.backend.entities;

public interface DtoConvertible<DTO> {
    DTO toDTO();
}