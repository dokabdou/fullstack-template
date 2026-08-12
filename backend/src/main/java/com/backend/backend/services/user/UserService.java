package com.backend.backend.services.user;

import com.backend.backend.dtos.auth.RegistrationDTO;
import com.backend.backend.dtos.user.UpdateUserDTO;
import com.backend.backend.dtos.user.UserDTO;
import com.backend.backend.utils.service.entity.CRUDEntityService;

public interface UserService extends CRUDEntityService<UserDTO, RegistrationDTO, UpdateUserDTO> {
}
