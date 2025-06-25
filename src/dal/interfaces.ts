export interface IDal {
  getAll(): Promise<any[]>;
  getById(id: string): Promise<any>;
  create(item: any): Promise<any>;
  update(id: string, item: any): Promise<any>;
  delete(id: string): Promise<void>;
}
