def main(_) -> str:
    pass


def handle_result(args, answer, target_window_id, boss) -> None:
    import kitty.fast_data_types as f

    os_window_id = f.current_focused_os_window_id()
    current_opacity = f.background_opacity_of(os_window_id)
    if current_opacity == 1:
        boss.set_background_opacity("default")
    else:
        boss.set_background_opacity("1")


handle_result.no_ui = True
