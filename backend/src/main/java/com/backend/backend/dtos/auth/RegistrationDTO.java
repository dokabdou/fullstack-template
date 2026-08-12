package com.backend.backend.dtos.auth;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public record RegistrationDTO(
        @NotNull String firstname,
        @NotNull String lastname,
        LocalDate birthdate,
        @NotNull String email,
        @NotNull String password,
		@NotNull LocalDateTime createdAt,
		@NotNull LocalDateTime updatedAt,
        @NotNull List<UUID> rolesIds) { }