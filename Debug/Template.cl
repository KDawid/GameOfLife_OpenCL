constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST;

__kernel void StepOneGeneration(read_only image2d_t gameOfLifeInput, write_only image2d_t gameOfLifeOutput)
{
	const int x = get_global_id(0);
	const int y = get_global_id(1);

	// Actual cell state
	uint A = read_imageui(gameOfLifeInput, sampler, (int2)(x, y)).x;

	// Count alive neighbours
	int sum = 0;
	for(int i = -1; i <= 1; i++)
	{
		for (int j = -1; j <= 1; j++)
		{
			if(!(i == 0 && j == 0))
			{
				if(!(x + i < 0 || x + i >= get_image_height(gameOfLifeInput) || y + j < 0 || y + j >= get_image_width(gameOfLifeInput)))
				{
					sum += read_imageui(gameOfLifeInput, sampler, (int2)(x + i, y + j)).x;
				}
			}
		}
	}
	// Update cell state
	if(sum == 3 || (A == 1 && sum == 2))
	{
		write_imageui(gameOfLifeOutput, (int2)(x, y), 1);
	}
	else
	{
		write_imageui(gameOfLifeOutput, (int2)(x, y), 0);
	}
	//printf("(%i, %i) - %i --> %i neighbours\n", x, y, A, sum);
}
