package com.backend.backend.dtos.role;
import com.backend.backend.enums.RoleName;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

public record RoleDTO(@NotNull UUID id, @NotNull RoleName name) {
}
