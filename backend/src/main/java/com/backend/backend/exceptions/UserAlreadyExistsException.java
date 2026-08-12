package com.backend.backend.exceptions;

public class UserAlreadyExistsException extends BackendException {
    public UserAlreadyExistsException(String message) {
        super(message);
    }
}
