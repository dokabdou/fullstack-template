package com.backend.backend.utils.service.entity;

public interface CRUDEntityService<DTO, CreateDTO, UpdateDTO> extends ReadableEntityService<DTO>, WritableEntityService<DTO, CreateDTO, UpdateDTO>, DeletableEntityService{
}
