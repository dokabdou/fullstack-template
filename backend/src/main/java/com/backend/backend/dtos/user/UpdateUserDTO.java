package com.backend.backend.dtos.user;

public record UpdateUserDTO(String firstname, String lastname, UpdateUserRoleDTO roles) { }
