package com.example.backend.controller;

import com.example.backend.model.AppUser;
import com.example.backend.repository.AppUserRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final AppUserRepository repo;

    public UserController(AppUserRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<AppUser> list() {
        return repo.findAll();
    }

    @PostMapping
    public AppUser create(@RequestBody AppUser user) {
        return repo.save(user);
    }
}