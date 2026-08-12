package com.backend.backend.dtos.auth;

public record AuthDTO(String token, String type, long expiresInMs, String firstname) {
}
