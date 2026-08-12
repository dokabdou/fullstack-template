package com.backend.backend.utils.service.entity;

import java.util.UUID;

public interface UpdatableEntityService<DTO, UpdateDTO> {
    DTO update(UUID id, UpdateDTO dto);
}
