package com.backend.backend.exceptions.auth;

import com.backend.backend.exceptions.BackendException;

public class InvalidCredentialsException extends BackendException {
    public InvalidCredentialsException(String msg) {
        super(msg);
    }
}
