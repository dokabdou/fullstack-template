package com.backend.backend.utils.service.entity;

public interface CreatableEntityService<DTO, CreateDTO> {
    DTO create(CreateDTO dto);
}
