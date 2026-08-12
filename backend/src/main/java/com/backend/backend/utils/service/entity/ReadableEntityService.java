package com.backend.backend.utils.service.entity;

import java.util.List;
import java.util.UUID;

public interface ReadableEntityService <DTO> {
    List<DTO> all();
    DTO getById(UUID id);
}
