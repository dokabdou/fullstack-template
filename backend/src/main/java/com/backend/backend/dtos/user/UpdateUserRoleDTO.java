package com.backend.backend.dtos.user;

import jakarta.validation.constraints.NotNull;

import java.util.List;
import java.util.UUID;

public record UpdateUserRoleDTO(@NotNull List<UUID> newRoles, @NotNull List<UUID> oldRoles) {
}
