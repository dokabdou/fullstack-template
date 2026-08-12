package com.backend.backend.utils.service.entity;

import java.util.UUID;

public interface DeletableEntityService {
    UUID delete(UUID id);
}
