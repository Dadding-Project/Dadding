import { PartialType } from '@nestjs/mapped-types';
import { CreateUserDto } from './create-user.dto';
import { IsArray, IsDate, IsEmail, IsIn, IsString } from 'class-validator';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @IsString()
  displayName: string;

  @IsEmail()
  email: string;

  @IsArray()
  posts: Array<string>;

  @IsString()
  profilePicture: string;

  @IsString()
  tags: string;

  @IsDate()
  birthDate: Date;

  @IsString()
  @IsIn(['male', 'other'])
  gender: string;
}
