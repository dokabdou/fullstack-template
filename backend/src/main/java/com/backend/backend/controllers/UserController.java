package com.backend.backend.controllers;

import com.backend.backend.dtos.user.UpdateUserDTO;
import com.backend.backend.dtos.user.UserDTO;
import com.backend.backend.services.user.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/users")
public class UserController{
    private final UserService service;

    protected UserController(UserService service) {
        this.service = service;
    }

    @GetMapping("/")
    public ResponseEntity<List<UserDTO>> getAll(){
        return ResponseEntity.ok(service.all());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getById(@PathVariable UUID id){
        return ResponseEntity.ok(service.getById(id));
    }

    @PatchMapping("/{id}")
    public ResponseEntity<UserDTO> update(@PathVariable UUID id, @RequestBody UpdateUserDTO update){
        return ResponseEntity.ok(service.update(id, update));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<UUID> delete(@PathVariable UUID id){
        return ResponseEntity.ok(service.delete(id));
    }
}
