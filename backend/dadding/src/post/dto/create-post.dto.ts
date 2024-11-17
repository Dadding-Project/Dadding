import { IsArray, IsString } from 'class-validator';

export class CreatePostDto {
  @IsString()
  authorId: string;

  @IsString()
  content: string;

  @IsString()
  title: string;

  @IsString()
  comments: string;

  @IsArray()
  tags: Array<string>;

  @IsArray()
  images: Array<string>;
}
