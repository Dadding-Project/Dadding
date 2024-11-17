import { Type } from 'class-transformer';
import { IsDate, IsEmail, IsIn, IsString } from 'class-validator';

export class CreateUserDto {
  @IsString()
  displayName: string;

  @IsEmail()
  email: string;

  @IsString()
  profilePicture: string;

  @Type(() => Date)
  @IsDate()
  birthDate: Date;

  @IsString()
  @IsIn(['male', 'other'])
  gender: string;
}
