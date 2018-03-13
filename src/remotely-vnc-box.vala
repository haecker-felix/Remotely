/* remotely-vnc-box.vala
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

public enum Remotely.ZoomMode{
	FIT_WINDOW,
	BEST_FIT,
	ORIGINAL_SIZE
}

[GtkTemplate (ui = "/org/gnome/Remotely/ui/vnc-box.ui")]
public class Remotely.VncBox : Box {
	private Display display;

	[GtkChild] Box vnc_box;
	[GtkChild] ScrolledWindow scrolled_window;
	[GtkChild] Stack connection_stack;
	[GtkChild] Label status_label;

	[GtkChild] Revealer notification_revealer;
	[GtkChild] Stack notification_stack;
	[GtkChild] Label notification_label;

	[GtkChild] Entry username_entry;
	[GtkChild] Entry clientname_entry;
	[GtkChild] Entry password_entry;

	[GtkChild] Box username_box;
	[GtkChild] Box clientname_box;
	[GtkChild] Box password_box;

	public string host;
	public string port;

	public VncBox (string host, string port) {
		this.name = host;
		this.host = host;
		this.port = port;

		display = new Display();
		//display.depth = DisplayDepthColor.MEDIUM;
		display.local_pointer = true;
		//display.lossy_encoding = true;
		vnc_box.add(display);

		connect();

		connect_signals();
		this.show_all();
	}

	private void connect_signals(){
		display.vnc_connected.connect(() => {
			status_label.set_text("Warte auf Host...");
		});
		display.vnc_disconnected.connect(() => {
			status_label.set_text("Verbindung getrennt");
			connection_stack.set_visible_child_name("error");
		});
		display.vnc_initialized.connect(() => {
			connection_stack.set_visible_child_name("vnc");
		});
		display.vnc_auth_credential.connect((authlist) => {
			status_label.set_text("Warte auf Authentifizierung...");
			show_password_entry(authlist);
		});
		display.vnc_auth_failure.connect((error) => {
			show_notification("Authentifizierungsfehler");
			connection_stack.set_visible_child_name("error");
		});
		display.vnc_error.connect((error) => {
			show_notification(error);
			connection_stack.set_visible_child_name("error");
		});
		display.vnc_auth_unsupported.connect(() => {
			show_notification("Authentifizierung wird nicht unterstützt");
			connection_stack.set_visible_child_name("error");
		});
	}

	private void connect(){
		status_label.set_text("Verbindung wird hergestellt...");
		display.open_host(host,port);
	}

	public void disconnect(){
		display.close();
		this.destroy();
	}

	public void set_view_only(bool b){
		display.read_only = b;
	}

	public void set_zoom_mode(ZoomMode mode){
		switch(mode){
			case ZoomMode.FIT_WINDOW: {
				display.expand=true;
				display.set_scaling(true);
				display.height_request = 0;
				display.width_request = 0;
				scrolled_window.hscrollbar_policy = PolicyType.NEVER;
				scrolled_window.vscrollbar_policy = PolicyType.NEVER;
				break;
			}
			case ZoomMode.BEST_FIT: {
				display.expand=false;
				display.set_scaling(true);
				//display.height_request = vnc_box.get_allocated_heigth();
				//display.width_request = vnc_box.get_allocated_heigth();
				scrolled_window.hscrollbar_policy = PolicyType.NEVER;
				scrolled_window.vscrollbar_policy = PolicyType.NEVER;
				break;
			}
			case ZoomMode.ORIGINAL_SIZE: {
				display.expand=false;
				display.set_scaling(false);
				display.height_request = display.height;
				display.width_request = display.width;
				scrolled_window.hscrollbar_policy = PolicyType.ALWAYS;
				scrolled_window.vscrollbar_policy = PolicyType.ALWAYS;
				break;
			}
		}
	}

	private void show_notification(string text){
		notification_label.set_label(text);
		notification_revealer.set_reveal_child(true);
		notification_stack.set_visible_child_name("notification");
	}

	private void show_password_entry(ValueArray authlist){
		notification_revealer.set_reveal_child(true);
		notification_stack.set_visible_child_name("auth");

		password_box.set_visible(false);
		username_box.set_visible(false);
		clientname_box.set_visible(false);

		foreach (Value val in authlist.values) {
			DisplayCredential cred = (DisplayCredential)val.get_enum();
			switch(cred){
				case DisplayCredential.PASSWORD: password_box.set_visible(true); break;
				case DisplayCredential.USERNAME: username_box.set_visible(true); break;
				case DisplayCredential.CLIENTNAME: clientname_box.set_visible(true); break;
			}
		}
	}

	[GtkCallback]
	private void reconnect_button_clicked(){
		connect();
	}

	[GtkCallback]
	private void notification_close_button_clicked(){
		notification_revealer.set_reveal_child(false);
	}

	[GtkCallback]
	private void password_cancel_button_clicked(){
		notification_revealer.set_reveal_child(false);
		display.close();
	}

	[GtkCallback]
	private void passwort_connect_button_clicked(){
		notification_revealer.set_reveal_child(false);

		display.set_credential(DisplayCredential.PASSWORD, password_entry.get_text());
		display.set_credential(DisplayCredential.USERNAME, username_entry.get_text());
		display.set_credential(DisplayCredential.CLIENTNAME, clientname_entry.get_text());
	}

	private void optiscale(int box_width, int box_heigth, int image_width, int image_heigth, out int newwidth, out int newheigth){

	}

}