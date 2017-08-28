local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
	if (GetConVar("toybox_showurl"):GetBool() == true) then
		self.HTMLControls = vgui.Create("DHTMLControls", self);
		self.HTMLControls:Dock(TOP)
	end
end

function PANEL:Paint()
	if (!self.Started) then
		self.Started = true;

		local homeURL = "https://toybox.rtm516.co.uk/"
		
		self.HTML = vgui.Create("DHTML", self)
		self.HTML:Dock(FILL)
		self.HTML:OpenURL("https://toybox.rtm516.co.uk/api/keyLogin.php?key="..GetConVar("toybox_key"):GetString())
		self.HTML:SetAllowLua(true)
		
		if (GetConVar("toybox_showurl"):GetBool() == true) then
			self.HTMLControls:SetHTML(self.HTML)
			self.HTMLControls.AddressBar:SetText(homeURL)
			self.HTMLControls.HomeURL = homeURL
			local HTMLControls = self.HTMLControls
		end

		function self.HTML:OnDocumentReady(url)
			self:Call("isIngame();")
		end

		function self.HTML:ConsoleMessage(msg)
			print(msg)
		end
		
		self:InvalidateLayout()
	end
end

local CreationSheet = vgui.RegisterTable(PANEL, "Panel")

local function CreateContentPanel()
	local ctrl = vgui.CreateFromTable(CreationSheet)
	return ctrl
end

spawnmenu.AddCreationTab("Toybox", CreateContentPanel, "icon16/weather_clouds.png", 1000)