data:extend(
{
	-- Fonts
	{
		type = "font",
		name = "small-font",
		from = "default",
		border = false,
		size = 11
	},
	{
		type = "font",
		name = "bold-font",
		from = "default-bold",
		border = false,
		size = 14
	},
	{
		type = "font",
		name = "smaller-button-font",
		from = "default-bold",
		border = false,
		size = 18
	},
	{
		type = "font",
		name = "smallest-button-font",
		from = "default-bold",
		border = false,
		size = 12
	},
	--Sprites
	{
		type = "sprite",
		name = "sprite-outpost",
		filename = "__VersepellesOutposts__/graphics/icons/outpost-group.png",
		width = 64,
		height = 64,
	},
	{
		type = "sprite",
		name = "sprite-promethian",
		filename = "__VersepellesOutposts__/graphics/icons/electrolyzed-promethian-dust.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-novitian",
		filename = "__VersepellesOutposts__/graphics/icons/electrolyzed-novitian-dust.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-alien",
		filename = "__VersepellesOutposts__/graphics/icons/reactive-alien-alloy.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-fuel",
		filename = "__VersepellesOutposts__/graphics/icons/modified-rocket-fuel.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-other",
		filename = "__VersepellesOutposts__/graphics/icons/other.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-circuit",
		filename = "__base__/graphics/icons/electronic-circuit.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-advanced",
		filename = "__base__/graphics/icons/advanced-circuit.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-processing",
		filename = "__base__/graphics/icons/processing-unit.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "sprite-satellite",
		filename = "__base__/graphics/icons/satellite.png",
		width = 32,
		height = 32,
	},
})

local default_gui = data.raw["gui-style"].default

default_gui.thin_frame_style =
    {
      type = "frame_style",
      font = "default-frame",
      font_color = {r=1, g=1, b=1},
      -- padding of the title area of the frame, when the frame title
      -- is empty, the area doesn't exist and these values are not used
      title_top_padding = 0,
      title_left_padding = 0,
      title_bottom_padding = 0,
      title_right_padding = 0,
      -- padding of the content area of the frame
      top_padding  = 0,
      right_padding = 0,
      bottom_padding = 0,
      left_padding = 0,
      graphical_set =
      {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {8, 0}
      },
      flow_style=
      {
        horizontal_spacing = 0,
        vertical_spacing = 0
      }
    }

default_gui.thin_flow_style = 
	{
		type = "flow_style",
		
		top_padding = 0,
		bottom_padding = 0,
		left_padding = 0,
		right_padding = 0,
		
		horizontal_spacing = 0,
		vertical_spacing = 0,
		resize_row_to_width = true,
		resize_to_row_height = true,
		max_on_row = 1,
		
		graphical_set = { type = "none" },
	}

default_gui.small_label_style =
	{
		type="label_style",
		parent="label_style",
		font="small-font",
		align = "left",
		default_font_color={r=1, g=1, b=1},
		hovered_font_color={r=1, g=1, b=1},
		top_padding = 0,
		right_padding = 1,
		bottom_padding = 0,
		left_padding = 1,
	}

default_gui.bold_label_style =
	{
		type="label_style",
		parent="label_style",
		font="bold-font",
		align = "left",
		default_font_color={r=1, g=1, b=1},
		hovered_font_color={r=1, g=1, b=1},
		top_padding = 0,
		right_padding = 1,
		bottom_padding = 0,
		left_padding = 1,
	}

default_gui.minimize_button_style = 
	{
		type="button_style",
		parent="button_style",
		font="smallest-button-font",
		align = "center",
		default_font_color={r=0.8},
		hovered_font_color={r=1.0},
		top_padding = 0,
		right_padding = 3,
		bottom_padding = 0,
		left_padding = 2,
		left_click_sound =
		{
			{
			  filename = "__core__/sound/gui-click.ogg",
			  volume = 1
			}
		},
	}

default_gui.launch_button_style = 
	{
		type="button_style",
		parent="button_style",
		font="smaller-button-font",
		align = "center",
		default_font_color={r=0.8},
		hovered_font_color={r=1.0},
		top_padding = 0,
		right_padding = 2,
		bottom_padding = 0,
		left_padding = 2,
		left_click_sound =
		{
			{
			  filename = "__core__/sound/gui-click.ogg",
			  volume = 1
			}
		},
	}

default_gui.large_outpost_sprite_style = 
	{
		type="button_style",
		parent="button_style",
		top_padding = 0,
		right_padding = 0,
		bottom_padding = 0,
		left_padding = 0,
		width = 64,
		height = 64,
		scalable = false,
	}

default_gui.outpost_sprite_style = 
	{
		type="button_style",
		parent="button_style",
		top_padding = 5,
		right_padding = 5,
		bottom_padding = 5,
		left_padding = 5,
		width = 42,
		height = 42,
		scalable = false,
	}

default_gui.promethian_progressbar_style =
    {
		type = "progressbar_style",
		smooth_color = {g=0.5},
    }

default_gui.novitian_progressbar_style =
    {
		type = "progressbar_style",
		smooth_color = {r=0.35, b=0.7},
    }

default_gui.alien_progressbar_style =
    {
		type = "progressbar_style",
		smooth_color = {g=0.5, b=0.8},
    }

default_gui.fuel_progressbar_style =
    {
		type = "progressbar_style",
		smooth_color = {r=1, g=1},
    }

default_gui.other_progressbar_style =
    {
		type = "progressbar_style",
		smooth_color = {r=0.5, g=0.5, b=0.5},
    }