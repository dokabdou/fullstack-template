package com.backend.backend.services.role;

import com.backend.backend.dtos.role.RoleDTO;
import com.backend.backend.entities.Role;
import com.backend.backend.exceptions.RoleNotFoundException;
import com.backend.backend.repositories.RoleRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class RoleServiceImpl implements RoleService{

    Logger logger = LoggerFactory.getLogger(RoleServiceImpl.class);

    RoleRepository repository;

    RoleServiceImpl(RoleRepository repository){
        this.repository = repository;
    }

    @Override
    public List<RoleDTO> all() {
        return repository.findAll().stream().map(Role::toDTO).toList();
    }

    @Override
    public RoleDTO getById(UUID id) {
        logger.info("Get Role {}...", id);
        return repository.findById(id)
                .map(Role::toDTO)
                .orElseThrow(() -> new RoleNotFoundException(String.format("getRoleById %s not found.", id)));
    }
}
