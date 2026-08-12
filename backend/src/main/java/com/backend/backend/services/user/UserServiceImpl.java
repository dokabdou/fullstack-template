package com.backend.backend.services.user;

import com.backend.backend.dtos.auth.RegistrationDTO;
import com.backend.backend.dtos.user.UpdateUserDTO;
import com.backend.backend.dtos.user.UserDTO;
import com.backend.backend.entities.Role;
import com.backend.backend.entities.User;
import com.backend.backend.exceptions.UserAlreadyExistsException;
import com.backend.backend.exceptions.UserNotFoundException;
import com.backend.backend.repositories.RoleRepository;
import com.backend.backend.repositories.UserRepository;
import com.backend.backend.utils.BaseEntity;
import org.apache.tomcat.util.digester.ArrayStack;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class UserServiceImpl implements UserService {

    Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserRepository repository;
    private final RoleRepository roleRepository;

    public UserServiceImpl(UserRepository repository, RoleRepository roleRepository){
        this.repository = repository;
        this.roleRepository = roleRepository;
    }

    @Override
    public List<UserDTO> all() {
        logger.info("Find all users...");
        return repository.findAll().stream().map(User::toDTO).toList();
    }

    @Override
    public UserDTO create(RegistrationDTO registration) {
        logger.info("User creation...");

        Optional<User> existing = repository.findByEmail(registration.email());

        if(existing.isEmpty()){
            logger.info("Saving user...");
            PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

            List<Role> roles = roleRepository.findAllById(registration.rolesIds());

            User savedUser = repository.save(new User(registration.firstname(),registration.lastname(),registration.birthdate(), registration.email(), passwordEncoder.encode(registration.password()), registration.createdAt(), registration.updatedAt(), roles));

            logger.info("New user saved !");
            return savedUser.toDTO();
        }
        throw new UserAlreadyExistsException("A user with the email '%s' already exists".formatted(registration.email()));
    }

    @Override
    public UserDTO update(UUID userId, UpdateUserDTO update) {
        logger.info("Update user {}...", userId);

        User user = repository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(String.format("updateUser with id %s not found", userId)));

        if (update.firstname() != null && !update.firstname().isBlank())
            user.setFirstname(update.firstname());
        if (update.lastname() != null && !update.lastname().isBlank())
            user.setLastname(update.lastname());

        if (update.roles() != null){
            List<UUID> newRolesIds = update.roles().newRoles().stream().filter(id -> !user.getRoles().stream().map(BaseEntity::getId).toList().contains(id)).toList();
            List<Role> toDelete = user.getRoles().stream().filter(role -> update.roles().oldRoles().contains(role.getId())).toList();


            if(!toDelete.isEmpty()){
                user.setRoles(user.getRoles().stream().filter(role -> !toDelete.contains(role)).collect(Collectors.toCollection(ArrayStack::new)));
            }

            if(!newRolesIds.isEmpty()) {
                List<Role> roles = roleRepository.findAllById(newRolesIds);
                user.getRoles().addAll(roles);
            }
        }

        return repository.save(user).toDTO();
    }

    @Override
    public UUID delete(UUID id) {
        logger.info("Delete user {}...", id);

        User user = repository.findById(id).orElseThrow(() -> new UserNotFoundException(String.format("deleteUser with id %s not found", id)));

        repository.delete(user);
        return id;
    }

    @Override
    public UserDTO getById(UUID userId) {
        logger.info("Get user {}...", userId);
        return repository.findById(userId)
                .map(User::toDTO)
                .orElseThrow(() -> new UserNotFoundException(String.format("getUser %s not found.", userId)));
    }
}
