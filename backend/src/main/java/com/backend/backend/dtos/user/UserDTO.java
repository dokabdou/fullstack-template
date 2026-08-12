package com.backend.backend.dtos.user;

import com.backend.backend.dtos.role.RoleDTO;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public record UserDTO(
        @NotNull UUID id,
        @NotNull String email,
        @NotNull String firstname,
        @NotNull String lastname,
        LocalDate birthdate,
		LocalDateTime createdAt,
		LocalDateTime updatedAt,
        @NotNull List<RoleDTO> roles) {
}
