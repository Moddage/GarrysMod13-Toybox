if !game.SinglePlayer() then return end

local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
	if (GetConVar("Funbox_showurl"):GetBool() == true) then
		self.HTMLControls = vgui.Create("DHTMLControls", self);
		self.HTMLControls:Dock(TOP)
	end

	concommand.Add("Funbox_search", function(_,_,arg)
		self.HTML:RunJavascript('document.getElementById("srch-term").value = "'..arg[1]..'";')
	end)
end

function PANEL:Paint()
	if (!self.Started) then
		self.Started = true;

		local homeURL = "https://funbox.moddage.site/ingame/"
		
		self.HTML = vgui.Create("DHTML", self)
		self.HTML:Dock(FILL)
		self.HTML:OpenURL(homeURL)
		self.HTML:SetAllowLua(true)
		
		if (GetConVar("Funbox_showurl"):GetBool() == true) then
			self.HTMLControls:SetHTML(self.HTML)
			self.HTMLControls.AddressBar:SetText(homeURL)
			self.HTMLControls.HomeURL = homeURL
			local HTMLControls = self.HTMLControls

			function self.HTML:OnBeginLoadingDocument(url)
				HTMLControls.AddressBar:SetText(url)
			end
		end

		function self.HTML:OnDocumentReady(url)
			self:Call("ingame = true;")
		end
		
		self:InvalidateLayout()
	end
end

local CreationSheet = vgui.RegisterTable(PANEL, "Panel")

local function CreateContentPanel()
	local ctrl = vgui.CreateFromTable(CreationSheet)
	return ctrl
end

spawnmenu.AddCreationTab("Funbox", CreateContentPanel, "icon16/weather_clouds.png", 1000)