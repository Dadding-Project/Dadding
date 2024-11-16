export interface Post {
  id?: string;
  title: string;
  content: string;
  authorId: string;
  tags: Array<string>;
  commentCount: number;
  images: Array<string>;
  createdAt: Date;
  updatedAt: Date | null;
}
