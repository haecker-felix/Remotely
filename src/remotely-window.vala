/* remotely-window.vala
 *
 * Copyright (C) 2018 Felix Häcker
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Vnc;
using Gtk;

[GtkTemplate (ui = "/org/gnome/Remotely/ui/window.ui")]
public class Remotely.Window : Gtk.ApplicationWindow {

	[GtkChild] Entry connect_entry;
	[GtkChild] CheckButton view_only_checkbutton;
	[GtkChild] Popover new_connection_popover;

	[GtkChild] Revealer connection_revealer;
	[GtkChild] Notebook vnc_notebook;
	[GtkChild] Stack vnc_stack;
	[GtkChild] HeaderBar header_bar;

	public Window (Gtk.Application app) {
		Object (application: app);

		var gtk_settings = Gtk.Settings.get_default ();
		gtk_settings.gtk_application_prefer_dark_theme = true;

		vnc_notebook.page_added.connect(update_view);
		vnc_notebook.page_removed.connect(update_view);
		vnc_notebook.switch_page.connect((page, num) => {
			VncBox cbox = (VncBox)page;
			header_bar.set_subtitle("%s".printf(cbox.host));
		});
	}

	[GtkCallback]
	private void connect_button_clicked(){
		VncBox cbox = new VncBox(connect_entry.get_text(),"5902");

		Gtk.Box titlebox = new Gtk.Box(Orientation.HORIZONTAL,0);
		Gtk.Label title = new Gtk.Label (connect_entry.get_text());
		title.expand = true;

		Gtk.Button close_button = new Gtk.Button.from_icon_name("window-close-symbolic", IconSize.MENU);
		close_button.clicked.connect(() => {cbox.disconnect();});
		close_button.relief = ReliefStyle.NONE;

		titlebox.add(title);
		titlebox.add(close_button);
		titlebox.expand = true;
		titlebox.show_all();
		vnc_notebook.append_page(cbox, titlebox);

		vnc_notebook.set_current_page(vnc_notebook.page_num(cbox));
		vnc_notebook.set_tab_reorderable(cbox,true);

		new_connection_popover.hide();
		connect_entry.set_text("");
	}

	[GtkCallback]
	private void disconnect_button_clicked(){
		VncBox cbox = (VncBox)vnc_notebook.get_nth_page(vnc_notebook.get_current_page());
		cbox.disconnect();
	}

	[GtkCallback]
	private void zoom_fit_window_button_clicked(){
		VncBox cbox = (VncBox)vnc_notebook.get_nth_page(vnc_notebook.get_current_page());
		cbox.set_zoom_mode(ZoomMode.FIT_WINDOW);
	}

	[GtkCallback]
	private void zoom_best_fit_button_clicked(){
		VncBox cbox = (VncBox)vnc_notebook.get_nth_page(vnc_notebook.get_current_page());
		cbox.set_zoom_mode(ZoomMode.BEST_FIT);
	}

	[GtkCallback]
	private void zoom_original_button_clicked(){
		VncBox cbox = (VncBox)vnc_notebook.get_nth_page(vnc_notebook.get_current_page());
		cbox.set_zoom_mode(ZoomMode.ORIGINAL_SIZE);
	}

	[GtkCallback]
	private void view_only_checkbutton_clicked(){
		VncBox cbox = (VncBox)vnc_notebook.get_nth_page(vnc_notebook.get_current_page());
		cbox.set_view_only(view_only_checkbutton.active);
	}

	private void update_view(){
		if(vnc_notebook.get_n_pages() > 1) vnc_notebook.show_tabs = true;
		else vnc_notebook.show_tabs = false;

		if(vnc_notebook.get_n_pages() == 0){
			vnc_stack.set_visible_child_name("no-connection");
			connection_revealer.set_reveal_child(false);
		}else{
			vnc_stack.set_visible_child_name("notebook");
			connection_revealer.set_reveal_child(true);
		}
	}
}
