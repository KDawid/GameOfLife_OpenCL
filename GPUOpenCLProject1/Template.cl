/*****************************************************************************
 * Copyright (c) 2013-2016 Intel Corporation
 * All rights reserved.
 *
 * WARRANTY DISCLAIMER
 *
 * THESE MATERIALS ARE PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL OR ITS
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THESE
 * MATERIALS, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Intel Corporation is the author of the Materials, and requests that all
 * problem reports or change requests be submitted to it directly
 *****************************************************************************/

constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST;

__kernel void StepOneGeneration(read_only image2d_t gameOfLifeInput, write_only image2d_t gameOfLifeOutput)
{
	const int x = get_global_id(0);
	const int y = get_global_id(1);

	uint A = read_imageui(gameOfLifeInput, sampler, (int2)(x, y)).x;

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
