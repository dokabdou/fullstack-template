package com.backend.backend.utils.service.entity;

public interface WritableEntityService<DTO, CreateDTO, UpdateDTO> extends CreatableEntityService<DTO,CreateDTO>, UpdatableEntityService<DTO,UpdateDTO>{}
