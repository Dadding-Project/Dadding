import { Inject, Injectable } from '@nestjs/common';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { Post } from './entities/post.entity';
import { ResponseStrategy } from '../shared/strategies/response.strategy';
import { AppRepository } from 'src/app.repository';

@Injectable()
export class PostService {
  constructor(
    @Inject('POST_REPOSITORY')
    private postRepository: AppRepository<Post>,
    private responseStrategy: ResponseStrategy,
  ) {}

  async create(createPostDto: CreatePostDto) {
    try {
      const post: Post = {
        ...createPostDto,
        createdAt: new Date(),
        commentCount: 0,
        updatedAt: null,
      };
      const id = await this.postRepository.create(post);
      return this.responseStrategy.success('Post created successfully', {
        id,
        ...post,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to create post', error);
    }
  }

  async findAll() {
    try {
      const posts = await this.postRepository.findAll();
      return posts.length === 0
        ? this.responseStrategy.noContent('No posts found')
        : this.responseStrategy.success('Posts retrieved successfully', posts);
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve posts', error);
    }
  }

  async findOne(id: string) {
    try {
      const post = await this.postRepository.findOne(id);
      return post
        ? this.responseStrategy.success('Post retrieved successfully', post)
        : this.responseStrategy.notFound('Post not found');
    } catch (error) {
      return this.responseStrategy.error('Failed to retrieve post', error);
    }
  }

  async update(id: string, updatePostDto: UpdatePostDto) {
    try {
      const existingPost = await this.postRepository.findOne(id);
      if (!existingPost) {
        return this.responseStrategy.notFound('Post not found');
      }
      const updatedPost: Partial<Post> = {
        ...updatePostDto,
        updatedAt: new Date(),
      };
      await this.postRepository.update(id, updatedPost);
      return this.responseStrategy.success('Post updated successfully', {
        id,
        ...existingPost,
        ...updatedPost,
      });
    } catch (error) {
      return this.responseStrategy.error('Failed to update post', error);
    }
  }

  async remove(id: string) {
    try {
      const existingPost = await this.postRepository.findOne(id);
      if (!existingPost) {
        return this.responseStrategy.notFound('Post not found');
      }
      await this.postRepository.remove(id);
      return this.responseStrategy.success('Post deleted successfully');
    } catch (error) {
      return this.responseStrategy.error('Failed to delete post', error);
    }
  }

  private formatLikedBy(likedBy: string | string[]): string {
    return Array.isArray(likedBy) ? likedBy.join(',') : likedBy;
  }
}
