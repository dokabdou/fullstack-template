package com.backend.backend.exceptions;

public class UserNotFoundException extends BackendException{
    public UserNotFoundException(String message) {
        super(message);
    }
}
