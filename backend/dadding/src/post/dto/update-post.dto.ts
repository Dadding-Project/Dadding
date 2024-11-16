import { PartialType } from '@nestjs/mapped-types';
import { CreatePostDto } from './create-post.dto';
import { IsArray, IsInt, IsString } from 'class-validator';

export class UpdatePostDto extends PartialType(CreatePostDto) {
  @IsString()
  authorId: string;

  @IsString()
  content: string;

  @IsInt()
  commentCount: number;

  @IsString()
  title: string;

  @IsArray()
  tags: Array<string>;

  @IsArray()
  images: Array<string>;
}
