import { IsDate, IsEmail, IsIn, IsString } from 'class-validator';

export class CreateUserDto {
  @IsString()
  displayName: string;

  @IsEmail()
  email: string;

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
