export interface CallerIdPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
