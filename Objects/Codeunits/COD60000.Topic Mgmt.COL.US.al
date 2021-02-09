codeunit 60000 "Topic Mgmt.COL.US"
{

    trigger OnRun()
    begin
        GenerateFolderStructure('C:\Tmp\portal');
        GenCSS('C:\Tmp\portal');
        GenScripts('C:\Tmp\portal');
        GenLearningHomePage('C:\Tmp\portal');
        Message('Complete');
    end;

    local procedure GenLearningHomePage(baseFolder: Text)
    var
        groups: Record "Topic Group.COL.US";
        topic: Record "Topics.COL.US";
        toFile: File;
        imgFilename, imgFilepath : text;
    begin
        // Generate the main page that list the topic groups
        groups.SetAutoCalcFields("Topci Count.COL.US", "Time.COL.US", "Media.COL.US");
        if groups.FindSet() then begin
            Clear(toFile);
            toFile.TextMode := true;
            toFile.Create(StrSubstNo('%1\%2\topics.html', baseFolder, groups."Version.COL.US"), TextEncoding::UTF8);
            GenTopicOverHeader(toFile);
            repeat

                toFile.Write('<div class="topic-container">');
                toFile.Write('<div class="topic-header"></div>');
                imgFilename := StrSubstNo('%1.media', groups."Code.COL.US");
                imgFilepath := StrSubstNo('%1\%2\Images', baseFolder, groups."Version.COL.US");
                if (groups."Media.COL.US".HasValue) then
                    groups."Media.COL.US".Export(StrSubstNo('%1\%2', imgFilepath, imgFilename));
                toFile.Write('<img src="./images/' + imgFilename + '" class="topic-image">');
                // toFile.Write('<label class="topic-module">' + groups."Name.COL.US" + '</label>');
                toFile.Write('<a class="topic-title" href="C-US-' + groups."Code.COL.US" + '/Learning/topics.html">' + groups."Name.COL.US" + '</a>');
                toFile.Write(StrSubstNo('<label class="topic-time">%1 Units %2 mins</label>', groups."Topci Count.COL.US", groups."Time.COL.US"));
                toFile.Write('<label class="topic-desc">' + groups."Desc.COL.US" + '</label>');
                toFile.Write('</div>');

            until groups.Next() = 0;
            GenTopicOverFooter(toFile);
            toFile.Close();
        end;

        // Genearete a page for each group listing all the topics in that group
        if groups.FindSet() then
            repeat
                Clear(toFile);
                topic.SetAutoCalcFields("Units.COL.US", "Time.COL.US", "Media.COL.US");
                topic.SetRange("Group Code.COL.US", groups."Code.COL.US");
                topic.SetRange("Group Version.COL.US", groups."Version.COL.US");
                topic.SetRange("Type.COL.US", topic."Type.COL.US"::Learning);
                if topic.FindSet() then begin
                    Clear(toFile);
                    toFile.TextMode := true;
                    toFile.Create(StrSubstNo('%1\%2\C-US-%3\Learning\topics.html', baseFolder, groups."Version.COL.US", groups."Code.COL.US"), TextEncoding::UTF8);
                    GenTopicsHeader(toFile);
                    repeat
                        toFile.Write('<div class="topic-container">');
                        toFile.Write('<div class="topic-header"></div>');

                        imgFilename := StrSubstNo('%1.media', topic."Code.COL.US");
                        imgFilepath := StrSubstNo('%1\%2\C-US-%3\Learning\Images', baseFolder, topic."Group Version.COL.US", topic."Group Code.COL.US");
                        if (topic."Media.COL.US".HasValue) then
                            topic."Media.COL.US".Export(StrSubstNo('%1\%2', imgFilepath, imgFilename));
                        toFile.Write('<img src="./images/' + imgFilename + '" class="topic-image">');

                        toFile.Write('<label class="topic-module">' + groups."Name.COL.US" + '</label>');
                        //toFile.Write('<a class="topic-title" href="C-US-' + groups."Code.COL.US" + '/Learning/' + topic."Code.COL.US" + '/topic_overview.html">' + topic."Name.COL.US" + '</a>');
                        toFile.Write('<a class="topic-title" href="' + topic."Code.COL.US" + '/topic_overview.html">' + topic."Name.COL.US" + '</a>');
                        toFile.Write(StrSubstNo('<label class="topic-time">%1 Units %2 mins</label>', topic."Units.COL.US", topic."Time.COL.US"));
                        toFile.Write('<label class="topic-desc">' + topic."Desc.COL.US" + '</label>');
                        toFile.Write('</div>');
                        GenTopicStartPage(topic, StrSubstNo('%1\%2\C-US-%3\Learning\%4', baseFolder, groups."Version.COL.US", groups."Code.COL.US", topic."Code.COL.US"));
                    until topic.Next() = 0;
                    GenTopicsFooter(toFile);
                    toFile.Close();
                end;
            until groups.Next() = 0;
    end;

    local procedure GenTopicStartPage(var topic: Record "Topics.COL.US"; baseFolder: Text)
    var
        subTop: Record "Sub Topics.COL.US";
        toFile: File;
    begin
        toFile.TextMode := true;
        toFile.Create(StrSubstNo('%1\topic_overview.html', baseFolder), TextEncoding::UTF8);
        GenTopicStartPageHeader(toFile, topic);
        subTop.SetRange("Group Code.COL.US", topic."Group Code.COL.US");
        subTop.SetRange("Group Version.COL.US", topic."Group Version.COL.US");
        subTop.SetRange("Topic Code.COL.US", topic."Code.COL.US");
        subTop.SetRange("Topic Type.COL.US", topic."Type.COL.US");
        subTop.SetCurrentKey("Unit Number.COL.US");
        if subTop.FindSet() then
            repeat
                toFile.Write('<div class="topic-overview-module">');
                toFile.Write('<label class="topic-overview-module-title"><a href="./' + subTop."Code.COL.US" + '.html">' + subTop."Name.COL.US" + '</a></label> </br>');
                toFile.Write(StrSubstNo('<label class="topic-overview-module-time">%1 mins</label>', subTop."Time.COL.US"));
                toFile.Write('</div>');
                toFile.Write('</br>');
                GenSubTopicPage(subTop, baseFolder, subTop."Code.COL.US");
            until subTop.Next() = 0;
        GenTopicStartPageFooter(toFile);
    end;

    local procedure GenTopicStartPageHeader(var toFile: File; top: Record "Topics.COL.US")
    var
        able: Record "Topic Able.COL.US";
        grp: Record "Topic Group.COL.US";
        sub: Record "Sub Topics.COL.US";
    begin
        grp.Get(top."Group Code.COL.US", top."Group Version.COL.US");
        sub.SetRange("Group Code.COL.US", top."Group Code.COL.US");
        sub.SetRange("Group Version.COL.US", top."Group Version.COL.US");
        sub.SetRange("Topic Code.COL.US", top."Code.COL.US");
        sub.SetRange("Topic Type.COL.US", top."Type.COL.US");
        sub.SetCurrentKey("Unit Number.COL.US");
        if sub.FindFirst() then;

        top.CalcFields("Units.COL.US", "Time.COL.US");
        toFile.Write('<html>');
        toFile.Write('<head>');
        toFile.Write('<link rel=''stylesheet'' href="../../../../css/main.css">');
        toFile.Write('</head>');

        toFile.Write('<body>');
        toFile.Write('<div class="body-header">');
        toFile.Write('<div>');

        toFile.Write('<div class="nav-bar-left"><img src="../../../../images/columbus_logo.png" alt="columbus logo"></div>');
        toFile.Write('<div class="nav-bar">');
        toFile.Write('<!-- <div>|</div>  This is menu across the topic of the page');
        toFile.Write('<div>menu</div>');
        toFile.Write('<div>test</div> -->');
        toFile.Write('</div>');
        toFile.Write('<!-- <div class=nav-bar-right>');
        toFile.Write('<img src="../../images/search_icon.png" alt="search icon" height="15">');
        toFile.Write('<label> Search </label><input id=searchBar></input>');
        toFile.Write('</div> -->');
        toFile.Write('</div>');
        toFile.Write('</div>');
        toFile.Write('<section>');
        toFile.Write('<div class="body-main">');
        toFile.Write('<div class="path-bar"><a href="../../../index.html">Home</a> / <a href="../../../topics.html">Learn</a> / <a href="../topics.html">' + grp."Name.COL.US" + '</a></div>');
        toFile.Write('<div class="seperator"></div>');
        toFile.Write('<div class="topic-overview">');
        toFile.Write('<label class="topic-overview-header">' + top."Name.COL.US" + '</label></br>');
        toFile.Write(StrSubstNo('<label class="topic-overview-info">%1 min - Module - %2 Units </label><br/></br>', top."Time.COL.US", top."Units.COL.US"));
        toFile.Write('<div class="topic-overview-description">');
        toFile.Write('<label>' + top."Long Desc.COL.US" + '</label>');
        toFile.Write('</br>');
        toFile.Write('</br>');
        toFile.Write('<label>By the end of this module, you will be able to:</label>');
        able.SetRange("Group Code.COL.US", top."Group Code.COL.US");
        able.SetRange("Group Version.COL.US", top."Group Version.COL.US");
        able.SetRange("Topic Code.COL.US", top."Code.COL.US");
        able.SetRange("Topic Type.COL.US", top."Type.COL.US");
        if able.FindSet() then
            repeat
                toFile.Write('<li>' + able."Desc.COL.US" + '</li>');
            until able.Next() = 0;

        toFile.Write(' </br>');
        toFile.Write(StrSubstNo('<button class="startContBtn" onclick="document.location = ''./%1.html''">Start ></button>', sub."Code.COL.US"));
        toFile.Write('</br>');
        if top."PreReq.COL.US" <> '' then begin
            toFile.Write('<label>Prerequisites</label></br>');
            toFile.Write('<label>' + top."PreReq.COL.US" + '</label> </br>');
        end;
        toFile.Write('</br>');

    end;

    local procedure GenTopicStartPageFooter(var toFile: File)
    begin

    end;

    local procedure GenSubTopicPage(var sub: Record "Sub Topics.COL.US"; baseFolder: text; fileName: Text)
    var
        toFile: File;
    begin
        toFile.TextMode := true;
        toFile.Create(StrSubstNo('%1\%2.html', baseFolder, fileName), TextEncoding::UTF8);
        GenSubTopicHeader(toFile, sub);

        GenSubDetail(toFile, sub, baseFolder);

        GenSubTopicFooter(toFile, sub);
        tofile.Close();
    end;

    local procedure GenSubDetail(var toFile: File; var sub: record "Sub Topics.COL.US"; baseFolder: text)
    var
        det: Record "Sub Detail.COL.US";
        first: Boolean;
        txt: BigText;
        iStrm: InStream;
        imgFilename: Text;
        imgFilepath: Text;
        oStrm: OutStream;
    begin
        first := true;
        det.SetRange("Group Code.COL.US", sub."Group Code.COL.US");
        det.SetRange("Group Version.COL.US", sub."Group Version.COL.US");
        det.SetRange("Topic Code.COL.US", sub."Topic Code.COL.US");
        det.SetRange("Topic Type.COL.US", sub."Topic Type.COL.US");
        det.SetRange("Sub Topic Code.COL.US", sub."Code.COL.US");
        if det.FindSet() then
            repeat
                if not first then
                    toFile.Write('</br>');
                first := false;
                case det."Type.COL.US" of
                    "Detail Type.COL.US"::Text:
                        begin
                            clear(txt);
                            det.CalcFields("Txt.COL.US");
                            det."Txt.COL.US".CreateInStream(iStrm);
                            txt.Read(iStrm);

                            toFile.Write(StrSubstNo('<lable>%1</label>', format(txt)));
                        end;
                    "Detail Type.COL.US"::HJTML:
                        begin
                            clear(txt);
                            det.CalcFields("Txt.COL.US");
                            det."Txt.COL.US".CreateInStream(iStrm);
                            txt.Read(iStrm);

                            toFile.Write(format(txt));
                        end;
                    "Detail Type.COL.US"::Image:
                        begin
                            imgFilename := StrSubstNo('%1_%2.media', det."Sub Topic Code.COL.US", det."Id.COL.US");
                            imgFilepath := StrSubstNo('%1\Images', baseFolder);
                            det.CalcFields("Media.COL.US");
                            if det."Media.COL.US".HasValue then
                                det."Media.COL.US".Export(StrSubstNo('%1\%2', imgFilepath, imgFilename));

                            toFile.Write(StrSubstNo('<img id=%1 src="./images/%3" alt="%2" class="img-small" onclick="zoomImage(this)">', det."Id.COL.US", det."Desc.COL.US", imgFilename));
                        end;
                end;

            until det.Next() = 0;
    end;

    local procedure GenSubTopicHeader(var toFile: file; var sub: Record "Sub Topics.COL.US")
    var
        grp: Record "Topic Group.COL.US";
    begin
        grp.Get(sub."Group Code.COL.US", sub."Group Version.COL.US");
        toFile.Write('<html>');
        toFile.Write('<head>');
        toFile.Write('<link rel=''stylesheet'' href="../../../../css/main.css">');
        toFile.Write('<script async src="../../../../scripts/main.js"></script>');
        toFile.Write('</head>');
        toFile.Write('<body>');
        toFile.Write('<div class="body-header">');
        toFile.Write('<div>');
        toFile.Write('<div class="nav-bar-left"><img src="../../../../images/columbus_logo.png" alt="columbus logo"></div>');
        toFile.Write('<div class="nav-bar">');
        toFile.Write('<!-- <div>|</div>  This is menu across the topic of the page');
        toFile.Write('<div>menu</div>');
        toFile.Write('<div>test</div> -->');
        toFile.Write('</div>');
        toFile.Write('<!-- <div class=nav-bar-right>');
        toFile.Write('<img src="../../images/search_icon.png" alt="search icon" height="15">');
        toFile.Write('<label> Search </label><input id=searchBar></input>');
        toFile.Write('</div> -->');
        toFile.Write('</div>');
        toFile.Write('</div>');
        toFile.Write('<section>');
        toFile.Write('<div class="body-main">');
        toFile.Write(StrSubstNo('<div class="path-bar"> <a href="../../../../index.html">Home</a> / <a href="../../../topics.html">Learn</a> / <a href="../topics.html">%1</a></div>', grp."Name.COL.US"));
        toFile.Write('<div class="seperator"></div>');
        toFile.Write('<div class="topic-overview">');
        toFile.Write(StrSubstNo('<label class="topic-overview-header">%1</label></br>', sub."Name.COL.US"));
        toFile.Write(StrSubstNo('<label class="topic-overview-info">%1 minutes - Unit %2 of %3</label><br/></br>', sub."Time.COL.US", sub."Unit Number.COL.US", sub.Count));
        toFile.Write('<div class="topic-overview-description">');

    end;

    local procedure GenSubTopicFooter(var toFile: file; var sub: Record "Sub Topics.COL.US")
    var
        grp: Record "Topic Group.COL.US";
        nextSub, prevSub : Record "Sub Topics.COL.US";
    begin
        nextSub.Copy(sub);
        prevSub.Copy(sub);

        toFile.Write('</br>');
        toFile.Write('</br>');
        toFile.Write('<hr style="width: 100%;margin-left: -10px;">');
        toFile.Write('</br>');
        if nextSub.Find('>') then
            toFile.Write(StrSubstNo('<label class="nextUnit">Next unit: %1</label>', nextSub."Name.COL.US"))
        else
            toFile.Write('<label class="nextUnit">Module Completed</label>');
        nextSub.Copy(sub);
        toFile.Write('</br>');
        toFile.Write('</br>');

        if not prevSub.Find('<') then
            toFile.Write('<button class="startContBtn " onclick="document.location=''./topic_overview.html'' ">&lt;')
        else
            toFile.Write(StrSubstNo('<button class="startContBtn " onclick="document.location=''%1.html'' ">&lt;', prevSub."Code.COL.US"));

        toFile.Write('Back</button>');
        if nextSub.Find('>') then
            toFile.Write(StrSubstNo('<button class="startContBtn" onclick="document.location = ''./%1.html''">Continue ></button>', nextSub."Code.COL.US"))
        else
            toFile.Write('<button class="startContBtn" onclick="document.location = ''../topics.html''">Modules ></button>');
        toFile.Write('</div>');

        toFile.Write('</div>');
        toFile.Write('<div id="cleared"></div>');
        toFile.Write('</div>');
        toFile.Write('</div>');
        toFile.Write('<div class="seperator"></div>');
        toFile.Write('</section>');
        toFile.Write('<div id="fullImageDiv" class="modal">');
        toFile.Write('<span class="close">&times;</span>');
        toFile.Write('<img class="modal-content" id="largeImage">');
        toFile.Write('<div id="caption"></div>');
        toFile.Write('</div>');
        // sidebar
        toFile.Write('<script>');
        toFile.Write('                var toggler = document.getElementsByClassName("caret");');
        toFile.Write('                var i;');
        toFile.Write('');
        toFile.Write('                for (i = 0; i < toggler.length; i++) {');
        toFile.Write('toggler[i].addEventListener("click", function () {');
        toFile.Write('this.parentElement.querySelector(".nested").classList.toggle("active");');
        toFile.Write('this.classList.toggle("caret-down");');
        toFile.Write('});');
        toFile.Write('                }');
        toFile.Write('</script>');
        // sidebar
        toFile.Write('</body>');
        toFile.Write('</html>');
    end;

    local procedure GenTopicsHeader(var toFile: File)
    begin
        toFile.Write('<html>');
        toFile.Write('');
        toFile.Write('<head>');
        toFile.Write('<link rel=''stylesheet'' href="../../../css/main.css">');
        toFile.Write('</head>');
        toFile.Write('');
        toFile.Write('<body>');
        toFile.Write('<div class="body-header">');
        toFile.Write('<div>');
        toFile.Write('');
        toFile.Write('<div class="nav-bar-left"><img src="../../images/columbus_logo.png" alt="columbus logo"></div>');
        toFile.Write('<div class="nav-bar">');
        toFile.Write('                <!-- <div>|</div>  This is menu across the topic of the page');
        toFile.Write('                <div>menu</div>');
        toFile.Write('                <div>test</div> -->');
        toFile.Write('</div>');
        toFile.Write('<!-- <div class=nav-bar-right>');
        toFile.Write('                <img src="images/search_icon.png" alt="search icon" height="15">');
        toFile.Write('                <label> Search </label><input id=searchBar></input>');
        toFile.Write('</div> -->');
        toFile.Write('</div>');
        toFile.Write('</div>');
        toFile.Write('<div class="body-main">');
        toFile.Write('<div class="path-bar"> <a href="../../index.html">Home</a> / <a href="../../topics.html">Learn</a></div>');
        toFile.Write('<div class="seperator"></div>');
        toFile.Write('  <div id="wrapper">');
        toFile.Write('    <div id="sidebar">');
        WriteSidebar(toFile);
        toFile.Write('</div>');
        toFile.Write('    <div id="content">');
        toFile.Write('<div id="filterNResults">');
        toFile.Write('<!-- <div class="filter-bar">Filter</div> THIS is the filter filter bar on the left-->');
        toFile.Write('<div></div>');
        toFile.Write('<div class="results-container">');
    end;

    local procedure GenTopicsFooter(var toFile: File)
    begin
        toFile.Write('          </div>');
        toFile.Write('        <div id="cleared"></div>');
        toFile.Write('      </div>');
        toFile.Write('    </div>');
        toFile.Write('  <div class="seperator"></div>');
        // sidebar
        toFile.Write('<script>');
        toFile.Write('                var toggler = document.getElementsByClassName("caret");');
        toFile.Write('                var i;');
        toFile.Write('');
        toFile.Write('                for (i = 0; i < toggler.length; i++) {');
        toFile.Write('toggler[i].addEventListener("click", function () {');
        toFile.Write('this.parentElement.querySelector(".nested").classList.toggle("active");');
        toFile.Write('this.classList.toggle("caret-down");');
        toFile.Write('});');
        toFile.Write('                }');
        toFile.Write('</script>');
        // sidebar
        toFile.Write('  </body>');
        toFile.Write('</html>        ');
    end;

    local procedure GenTopicOverHeader(var toFile: File)
    begin
        toFile.Write('<html>');
        toFile.Write('');
        toFile.Write('<head>');
        toFile.Write('<link rel=''stylesheet'' href="../css/main.css">');
        toFile.Write('</head>');
        toFile.Write('');
        toFile.Write('<body>');
        toFile.Write('<div class="body-header">');
        toFile.Write('<div>');
        toFile.Write('');
        toFile.Write('<div class="nav-bar-left"><img src="/images/columbus_logo.png" alt="columbus logo"></div>');
        toFile.Write('<div class="nav-bar">');
        toFile.Write('                <!-- <div>|</div>  This is menu across the topic of the page');
        toFile.Write('                <div>menu</div>');
        toFile.Write('                <div>test</div> -->');
        toFile.Write('</div>');
        toFile.Write('<!-- <div class=nav-bar-right>');
        toFile.Write('                <img src="images/search_icon.png" alt="search icon" height="15">');
        toFile.Write('                <label> Search </label><input id=searchBar></input>');
        toFile.Write('</div> -->');
        toFile.Write('</div>');
        toFile.Write('</div>');
        toFile.Write('<div class="body-main">');
        toFile.Write('<div class="path-bar"> <a href="./index.html">Home</a> / <a href="./topics.html">Learn</a></div>');
        toFile.Write('<div class="seperator"></div>');
        toFile.Write('  <div id="wrapper">');
        toFile.Write('    <div id="sidebar">');
        WriteSidebar(toFile);
        toFile.Write('</div>');
        toFile.Write('    <div id="content">');
        toFile.Write('<div id="filterNResults">');
        toFile.Write('<!-- <div class="filter-bar">Filter</div> THIS is the filter filter bar on the left-->');
        toFile.Write('<div></div>');
        toFile.Write('<div class="results-container">');
    end;

    local procedure GenTopicOverFooter(var toFile: File)
    begin
        toFile.Write('            </div>');
        toFile.Write('            <div id="cleared"></div>');
        toFile.Write('</div>');
        toFile.Write('</div>');
        toFile.Write('<div class="seperator"></div>');
        // sidebar
        toFile.Write('<script>');
        toFile.Write('                var toggler = document.getElementsByClassName("caret");');
        toFile.Write('                var i;');
        toFile.Write('');
        toFile.Write('                for (i = 0; i < toggler.length; i++) {');
        toFile.Write('toggler[i].addEventListener("click", function () {');
        toFile.Write('this.parentElement.querySelector(".nested").classList.toggle("active");');
        toFile.Write('this.classList.toggle("caret-down");');
        toFile.Write('});');
        toFile.Write('                }');
        toFile.Write('</script>');
        // sidebar
        toFile.Write('</body>');
        toFile.Write('</html>        ');
    end;

    local procedure GenDocHeader(var toFile: File)
    begin
        toFile.Write('<html>');

        toFile.Write('<head>');
        toFile.Write('    <link rel=''stylesheet'' href="./css/main.css">');
        toFile.Write('</head>');
        toFile.Write('<body>');
        toFile.Write('    <div class="body-header">');
        toFile.Write('        <div>');
        toFile.Write('            <div class="nav-bar-left"><img src="./images/columbus_logo.png" alt="columbus logo"></div>');
        toFile.Write('            <div class="nav-bar">');
        toFile.Write('                <!-- <div>|</div>  This is menu across the topic of the page');
        toFile.Write('                <div>menu</div>');
        toFile.Write('                <div>test</div> -->');
        toFile.Write('            </div>');
        toFile.Write('            <!-- <div class=nav-bar-right>');
        toFile.Write('                <img src="images/search_icon.png" alt="search icon" height="15">');
        toFile.Write('                <label> Search </label><input id=searchBar></input>');
        toFile.Write('            </div> -->');
        toFile.Write('        </div>');
        toFile.Write('    </div>');
        toFile.Write('    <div class="body-main">');
        toFile.Write('        <div class="path-bar"> <a href="./index.html">Home</a> / <a href="">Docs</a></div>');
        toFile.Write('        <div class="seperator"></div>');
        toFile.Write('  <div id="wrapper">');
        toFile.Write('    <div id="sidebar">');
        WriteSidebar(toFile);
        toFile.Write('</div>');
        toFile.Write('    <div id="content">');
        toFile.Write('        <div id="filterNResults">');
        toFile.Write('            <!-- <div class="filter-bar">Filter</div> THIS is the filter filter bar on the left-->');
        toFile.Write('            <div></div>');
    end;

    local procedure GenDocFooter(var toFile: File)
    begin
        toFile.Write('        </div>');
        toFile.Write('    </div>');
        toFile.Write('    <div class="seperator"></div>');
        // sidebar
        toFile.Write('<script>');
        toFile.Write('                var toggler = document.getElementsByClassName("caret");');
        toFile.Write('                var i;');
        toFile.Write('');
        toFile.Write('                for (i = 0; i < toggler.length; i++) {');
        toFile.Write('toggler[i].addEventListener("click", function () {');
        toFile.Write('this.parentElement.querySelector(".nested").classList.toggle("active");');
        toFile.Write('this.classList.toggle("caret-down");');
        toFile.Write('});');
        toFile.Write('                }');
        toFile.Write('</script>');
        // sidebar
        toFile.Write('</body>');

        toFile.Write('</html>');
    end;

    local procedure GenCSS(baseFolder: Text)
    begin
        GenLoginCSS(baseFolder);
        GenMainCSS(baseFolder);
    end;

    local procedure GenScripts(baseFolder: Text)
    begin
        GenMainJS(baseFolder);
    end;

    local procedure GenMainJS(baseFolder: text)
    var
        toFile: File;
    begin
        exit;
        toFile.TextMode := true;
        toFile.Create(StrSubstNo('%1\scripts\main.js', baseFolder), TextEncoding::UTF8);

        toFile.Write('var modal = document.getElementById("fullImageDiv");');
        toFile.Write('var modalImg = document.getElementById("largeImage");');
        toFile.Write('var captionText = document.getElementById("caption");');
        toFile.Write('');
        toFile.Write('function zoomImage(imgToZoom) {');
        toFile.Write('');
        toFile.Write('modal = document.getElementById("fullImageDiv");');
        toFile.Write('modalImg = document.getElementById("largeImage");');
        toFile.Write('captionText = document.getElementById("caption");');
        toFile.Write('');
        toFile.Write('modal.style.display = "block";');
        toFile.Write('modalImg.src = imgToZoom.src;');
        toFile.Write('captionText.innerHTML = imgToZoom.alt;');
        toFile.Write('}');
        toFile.Write('var span = document.getElementsByClassName("close")[0];');
        toFile.Write('span.onclick = function() {');
        toFile.Write('modal.style.display = "none";');
        toFile.Write('}');

        toFile.Close();

    end;

    local procedure GenLoginCSS(baseFolder: Text)
    var
        toFile: File;
    begin

    end;

    local procedure GenMainCSS(baseFolder: Text)
    var
        toFile: File;
    begin
        toFile.TextMode := true;
        toFile.Create(StrSubstNo('%1\css\main.css', baseFolder), TextEncoding::UTF8);

        toFile.Write(':root {');
        toFile.Write('--header-background: rgb(23, 23, 23);');
        toFile.Write('--header-fontColor: rgb(227, 227, 227);');
        toFile.Write('--body-background: rgba(36, 36, 36);');
        toFile.Write('--body-fontColor: rgb(227, 227, 227);');
        toFile.Write('--topic-titleColor: rgb(77, 178, 255);');
        toFile.Write('--topic-headerColor: rgb(0, 130, 114);');
        toFile.Write('--topic-timeColor: rgb(199, 199, 199);');
        toFile.Write('--buttonColor: rgb(77, 178, 255);');
        toFile.Write('--buttonHoverColor: rgb(0, 145, 255);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('html,');
        toFile.Write('html * {');
        toFile.Write('box-sizing: border-box;');
        toFile.Write('margin: 0;');
        toFile.Write('padding: 0;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('body {');
        toFile.Write('background-color: var(--body-background);');
        toFile.Write('padding: 0;');
        toFile.Write('margin: 0;');
        toFile.Write('font-family: ''Segoe UI'', Tahoma, Geneva, Verdana, sans-serif;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('header {');
        toFile.Write('position: fixed;');
        toFile.Write('padding: 2em;');
        toFile.Write('z-index: 1000;');
        toFile.Write('top: 0;');
        toFile.Write('left: 0;');
        toFile.Write('width: 100%;');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('nav {');
        toFile.Write('z-index: 400;');
        toFile.Write('top: 0;');
        toFile.Write('left: 0;');
        toFile.Write('opacity: .95;');
        toFile.Write('background: #fff;');
        toFile.Write('position: relative;');
        toFile.Write('display: block !important;');
        toFile.Write('float: right;');
        toFile.Write('width: 30%;');
        toFile.Write('padding: .75em 1em 0 0;');
        toFile.Write('height: 1.5em;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('footer {');
        toFile.Write('margin-top: -3em;');
        toFile.Write('padding: 8.75em 0 2em;');
        toFile.Write('height: 10vw;');
        toFile.Write('background-image: -moz-linear-gradient( -45deg, rgb(255, 91, 127) 0%, rgb(255, 213, 86) 100%);');
        toFile.Write('background-image: -webkit-linear-gradient( -45deg, rgb(255, 91, 127) 0%, rgb(255, 213, 86) 100%);');
        toFile.Write('background-image: -ms-linear-gradient( -45deg, rgb(255, 91, 127) 0%, rgb(255, 213, 86) 100%);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.body-header {');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('color: var(--header-fontColor);');
        toFile.Write('height: 54px;');
        toFile.Write('overflow: hidden;');
        toFile.Write('position: relative;');
        toFile.Write('width: 100%;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.seperator {');
        toFile.Write('background-color: var(--body-background);');
        toFile.Write('color: var(--body-fontColor);');
        toFile.Write('height: 10px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.seperator-header {');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('color: var(--body-fontColor);');
        toFile.Write('height: 41.5px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.nav-bar {');
        toFile.Write('background-color: green;');
        toFile.Write('display: inline-flex;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.nav-bar-left {');
        toFile.Write('background-color: red;');
        toFile.Write('display: inline-flex;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.nav-bar-right {');
        toFile.Write('display: inline-flex;');
        toFile.Write('float: right;');
        toFile.Write('overflow: hidden;');
        toFile.Write('border: solid;');
        toFile.Write('border-color: rgb(40, 40, 40);');
        toFile.Write('margin: 10px;');
        toFile.Write('padding: 5px;');
        toFile.Write('white-space: pre;');
        toFile.Write('align-items: center;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.signIn {');
        toFile.Write('display: inline-flex;');
        toFile.Write('float: right;');
        toFile.Write('font-size: small;');
        toFile.Write('overflow: hidden;');
        toFile.Write('margin: 10px;');
        toFile.Write('padding: 5px;');
        toFile.Write('white-space: pre;');
        toFile.Write('align-items: center;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.top-border {');
        toFile.Write('border-top: solid;');
        toFile.Write('border-color: rgb(40, 40, 40);');
        toFile.Write('border-top: thin;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.bottom-border {');
        toFile.Write('border-bottom: solid;');
        toFile.Write('border-bottom: thin;');
        toFile.Write('border-color: rgb(40, 40, 40);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.path-bar {');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('padding: 10px;');
        toFile.Write('/* white-space: pre; */');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.header-spacer {');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('white-space: pre;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.footer-spacer {');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('white-space: pre;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('#searchBar {');
        toFile.Write('background-color: transparent;');
        toFile.Write('border-style: solid;');
        toFile.Write('border-width: thin;');
        toFile.Write('color: var(--body-fontColor);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.body-main {');
        toFile.Write('background-color: var(--body-background);');
        toFile.Write('color: var(--body-fontColor);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('# wrapper {');
        toFile.Write('  margin-left: 200px;');
        toFile.Write('}');
        toFile.Write('#cleared {');
        toFile.Write('  clear: both;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('#sidebar {');
        toFile.Write('  float: left;');
        toFile.Write('  width: 200px;');
        toFile.Write('  margin-left: -200px;');
        toFile.Write('}');
        toFile.Write('#content {');
        toFile.Write('  float: right;');
        toFile.Write('  width: 100%;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('#filterNResults {');
        toFile.Write('  margin-left: 10px; ');
        toFile.Write('  float: left;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.filter-bar {');
        toFile.Write('background-color: orchid;');
        toFile.Write('float: left;');
        toFile.Write('width: 290px;');
        toFile.Write('margin-left: -310px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.results-container {');
        toFile.Write('float: right;');
        toFile.Write('width: 100%;');
        toFile.Write('margin-right: 10px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.cleared {');
        toFile.Write('clear: both;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-container {');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('margin: 10px;');
        toFile.Write('display: inline-block;');
        toFile.Write('width: 300px;');
        toFile.Write('border-style: none;');
        toFile.Write('border-top-left-radius: 0.5em;');
        toFile.Write('border-top-right-radius: 0.5em;');
        toFile.Write('height: 250px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-header {');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('width: 300px;');
        toFile.Write('background-color: var(--topic-headerColor);');
        toFile.Write('border-style: none;');
        toFile.Write('border-top-left-radius: 0.5em;');
        toFile.Write('border-top-right-radius: 0.5em;');
        toFile.Write('height: 40px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-module {');
        toFile.Write('/* position: relative; */');
        toFile.Write('display: flex;');
        toFile.Write('/* background-color: red; */');
        toFile.Write('margin-top: 5px;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('/* top: 20px; */');
        toFile.Write('/* left: 10px; */');
        toFile.Write('color: var(--body-fontColor)');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-title {');
        toFile.Write('/* position: relative; */');
        toFile.Write('/* background-color: blue; */');
        toFile.Write('display: flex;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('/* top: 40px;');
        toFile.Write('left: -45px; */');
        toFile.Write('color: var(--topic-titleColor);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-time {');
        toFile.Write('/* position: relative; */');
        toFile.Write('/* background-color: purple; */');
        toFile.Write('display: flex;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('font-size: x-small;');
        toFile.Write('/* top: 40px;');
        toFile.Write('left: -45px; */');
        toFile.Write('color: var(--topic-timeColor)');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-desc {');
        toFile.Write('display: flex;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('font-size: x-small;');
        toFile.Write('color: var(--body-fontColor);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-image {');
        toFile.Write('height: 50px;');
        toFile.Write('margin-top: -25px;');
        toFile.Write('margin-left: 10px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('a{');
        toFile.Write('color: rgb(130, 120, 222);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('a:link {');
        toFile.Write('text-decoration: none;');
        toFile.Write('    ');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('a:visited {');
        toFile.Write('color: rgb(130, 120, 222);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('a:hover {');
        toFile.Write('text-decoration: underline;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.signIn a:link {');
        toFile.Write('color: greenyellow;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.signIn a:visited {');
        toFile.Write('color: greenyellow;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-overview {');
        toFile.Write('position: relative;');
        toFile.Write('background-color: var(--header-background);');
        toFile.Write('/* height: 400px; */');
        toFile.Write('top: 20px;');
        toFile.Write('margin-left: 300px;');
        toFile.Write('margin-right: 300px;');
        toFile.Write('padding-bottom: 20px;');
        toFile.Write('padding-top: 20px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-overview-header {');
        toFile.Write('font-size: x-large;');
        toFile.Write('font-weight: bold;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-overview-info {');
        toFile.Write('font-size: x-small;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('columns: var(--topic-timeColor);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-overview-description {');
        toFile.Write('font-size: small;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-overview-module {');
        toFile.Write('font-size: small;');
        toFile.Write('margin-left: 20px;');
        toFile.Write('border-left-style: solid;');
        toFile.Write('border-left-color: gray;');
        toFile.Write('border-left-width: thick;');
        toFile.Write('padding-left: 5px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-overview-module-title {');
        toFile.Write('font-size: small;');
        toFile.Write('color: var(--topic-titleColor);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.topic-overview-module-time {');
        toFile.Write('font-size: x-small;');
        toFile.Write('color: topic-overview-module-time;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.nextUnit {');
        toFile.Write('/* font-size: medium; */');
        toFile.Write('font-weight: bold;');
        toFile.Write('/* margin-left: 20px; */');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.img-small {');
        toFile.Write('border-radius: 5px;');
        toFile.Write('cursor: pointer;');
        toFile.Write('transition: 0.3s;');
        toFile.Write('margin-left: auto;');
        toFile.Write('margin-right: auto;');
        toFile.Write('/* margin-left: -10px; */');
        toFile.Write('max-width: 90%;');
        toFile.Write('display: block;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.img-small:hover {');
        toFile.Write('opacity: 0.7;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.img-static {');
        toFile.Write('cursor: auto;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.img-static:hover {');
        toFile.Write('opacity: 1;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.startContBtn {');
        toFile.Write('background-color: var(--buttonColor);');
        toFile.Write('font-size: smaller;');
        toFile.Write('border: none;');
        toFile.Write('color: black;');
        toFile.Write('padding: 7px 16px;');
        toFile.Write('text-align: center;');
        toFile.Write('text-decoration: none;');
        toFile.Write('display: inline-block;');
        toFile.Write('margin: 4px 2px;');
        toFile.Write('cursor: pointer;');
        toFile.Write('transition-duration: 0.4s;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.startContBtn:hover {');
        toFile.Write('background-color: var(--buttonHoverColor);');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* from here down for image zoom */');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* The Modal (background) */');
        toFile.Write('');
        toFile.Write('.modal {');
        toFile.Write('display: none;');
        toFile.Write('/* Hidden by default */');
        toFile.Write('position: fixed;');
        toFile.Write('/* Stay in place */');
        toFile.Write('z-index: 1;');
        toFile.Write('/* Sit on top */');
        toFile.Write('padding-top: 100px;');
        toFile.Write('/* Location of the box */');
        toFile.Write('left: 0;');
        toFile.Write('top: 0;');
        toFile.Write('width: 100%;');
        toFile.Write('/* Full width */');
        toFile.Write('height: 100%;');
        toFile.Write('/* Full height */');
        toFile.Write('overflow: auto;');
        toFile.Write('/* Enable scroll if needed */');
        toFile.Write('background-color: rgb(0, 0, 0);');
        toFile.Write('/* Fallback color */');
        toFile.Write('background-color: rgba(0, 0, 0, 0.9);');
        toFile.Write('/* Black w/ opacity */');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* Modal Content (image) */');
        toFile.Write('');
        toFile.Write('.modal-content {');
        toFile.Write('margin: auto;');
        toFile.Write('display: block;');
        toFile.Write('width: 100%;');
        toFile.Write('/* width: 80%; */');
        toFile.Write('/* max-width: 700px; */');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* Caption of Modal Image */');
        toFile.Write('');
        toFile.Write('#caption {');
        toFile.Write('margin: auto;');
        toFile.Write('display: block;');
        toFile.Write('width: 80%;');
        toFile.Write('max-width: 700px;');
        toFile.Write('text-align: center;');
        toFile.Write('color: #ccc;');
        toFile.Write('padding: 10px 0;');
        toFile.Write('height: 150px;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* Add Animation */');
        toFile.Write('');
        toFile.Write('.modal-content,');
        toFile.Write('#caption {');
        toFile.Write('-webkit-animation-name: zoom;');
        toFile.Write('-webkit-animation-duration: 0.6s;');
        toFile.Write('animation-name: zoom;');
        toFile.Write('animation-duration: 0.6s;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('@-webkit-keyframes zoom {');
        toFile.Write('from {');
        toFile.Write('-webkit-transform: scale(0)');
        toFile.Write('}');
        toFile.Write('to {');
        toFile.Write('-webkit-transform: scale(1)');
        toFile.Write('}');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('@keyframes zoom {');
        toFile.Write('from {');
        toFile.Write('transform: scale(0)');
        toFile.Write('}');
        toFile.Write('to {');
        toFile.Write('transform: scale(1)');
        toFile.Write('}');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* The Close Button */');
        toFile.Write('');
        toFile.Write('.close {');
        toFile.Write('position: absolute;');
        toFile.Write('top: 15px;');
        toFile.Write('right: 35px;');
        toFile.Write('color: #f1f1f1;');
        toFile.Write('font-size: 40px;');
        toFile.Write('font-weight: bold;');
        toFile.Write('transition: 0.3s;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('.close:hover,');
        toFile.Write('.close:focus {');
        toFile.Write('color: #bbb;');
        toFile.Write('text-decoration: none;');
        toFile.Write('cursor: pointer;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* 100% Image Width on Smaller Screens */');
        toFile.Write('');
        toFile.Write('@media only screen and (max-width: 700px) {');
        toFile.Write('.modal-content {');
        toFile.Write('width: 100%;');
        toFile.Write('}');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('');
        toFile.Write('/* from here up for image zoom */');
        toFile.Write('');
        toFile.Write('table {');
        toFile.Write('/* font-family: arial, sans-serif; */');
        toFile.Write('border-collapse: collapse;');
        toFile.Write('font-size: small;');
        toFile.Write('width: 100%;');
        toFile.Write('margin-left: -10px;');
        toFile.Write('color: var(--body-fontColor);');
        toFile.Write('text-align: center;');
        toFile.Write('border: solid;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('td,');
        toFile.Write('th {');
        toFile.Write('border: solid;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('h3 {');
        toFile.Write('color: white;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('h3:visited {');
        toFile.Write('color: white;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('h3:hover {');
        toFile.Write('color: white;');
        toFile.Write('text-decoration: underline;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('h3:active {');
        toFile.Write('color: white;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('h3:link {');
        toFile.Write('text-decoration: none;');
        toFile.Write('}');
        toFile.Write('');
        toFile.Write('h3:hover {}');
        // New menu stuff
        toFile.Write('ul, #myUL {');
        toFile.Write('list-style-type: none;');
        toFile.Write('}   ');
        toFile.Write('#myUL {');
        toFile.Write('margin: 0;');
        toFile.Write('padding: 0;');
        toFile.Write('}    ');
        toFile.Write('.caret {');
        toFile.Write('cursor: pointer;');
        toFile.Write('-webkit-user-select: none; /* Safari 3.1+ */');
        toFile.Write('-moz-user-select: none; /* Firefox 2+ */');
        toFile.Write('-ms-user-select: none; /* IE 10+ */');
        toFile.Write('user-select: none;');
        toFile.Write('}    ');
        toFile.Write('.caret::before {');
        toFile.Write('content: "\25B6";');
        toFile.Write('color: rgb(255, 111, 0);');
        toFile.Write('display: inline-block;');
        toFile.Write('margin-right: 6px;');
        toFile.Write('}    ');
        toFile.Write('.caret-down::before {');
        toFile.Write('/* -ms-transform: rotate(90deg); /* IE 9 */');
        toFile.Write('/*-webkit-transform: rotate(90deg); /* Safari */');
        toFile.Write('transform: rotate(90deg);  ');
        toFile.Write('}    ');
        toFile.Write('.nested {');
        toFile.Write('display: none;            ');
        toFile.Write('}    ');
        toFile.Write('.active {');
        toFile.Write('display: block;');
        toFile.Write('}');


        toFile.Close();
    end;

    local procedure GenerateFolderStructure(baseFolder: Text)
    var
        groups: Record "Topic Group.COL.US";
        topic: Record "Topics.COL.US";
        sub: Record "Sub Topics.COL.US";
        v: Integer;
        vList: List of [Integer];
        grpFolder, topicFolder, versionFolder, grpDocFolder, grpLearnFolder, docTopicFolder : Text;
        fMgmt: Codeunit "File Management";
    begin
        if groups.FindSet() then
            repeat
                if not vList.Contains(groups."Version.COL.US") then
                    vList.Add(groups."Version.COL.US");
            until groups.Next() = 0;

        foreach v in vList do begin
            groups.SetRange("Version.COL.US", v);
            if groups.FindSet() then begin
                versionFolder := StrSubstNo('%1\%2', baseFolder, v);
                // MD versionFolder
                fMgmt.ServerCreateDirectory(versionFolder);

                fMgmt.ServerCreateDirectory(versionFolder + '\css');
                fMgmt.ServerCreateDirectory(versionFolder + '\images');
                fMgmt.ServerCreateDirectory(versionFolder + '\scripts');
                repeat
                    grpFolder := StrSubstNo('%1\C-US-%2', versionFolder, groups."Code.COL.US");
                    grpDocFolder := StrSubstNo('%1\Documentation', grpFolder);
                    grpLearnFolder := StrSubstNo('%1\Learning', grpFolder);
                    //grpLearnFolder := StrSubstNo('%1\Learning\Images', grpFolder);
                    // MD grpFolder
                    fMgmt.ServerCreateDirectory(grpFolder);
                    // MD grpDocFolder
                    fMgmt.ServerCreateDirectory(grpDocFolder);
                    // MD grpLearnFolder
                    fMgmt.ServerCreateDirectory(grpLearnFolder);
                    fMgmt.ServerCreateDirectory(grpLearnFolder + '\Images');
                    topic.SetRange("Group Code.COL.US", groups."Code.COL.US");
                    topic.SetRange("Group Version.COL.US", groups."Version.COL.US");
                    topic.SetRange("Type.COL.US", topic."Type.COL.US"::Documentation);
                    if topic.FindSet() then
                        repeat
                            docTopicFolder := StrSubstNo('%1\%2', grpDocFolder, topic."Code.COL.US");
                            // MD docTopicFolder
                            fMgmt.ServerCreateDirectory(docTopicFolder);
                            // MD StrSubstNo('%1\Images',docTopicFolder)
                            fMgmt.ServerCreateDirectory(StrSubstNo('%1\Images', docTopicFolder));
                        until topic.Next() = 0;

                    topic.SetRange("Type.COL.US", topic."Type.COL.US"::Learning);
                    if topic.FindSet() then
                        repeat
                            topicFolder := StrSubstNo('%1\%2', grpLearnFolder, topic."Code.COL.US");
                            // MD topicFolder
                            fMgmt.ServerCreateDirectory(topicFolder);
                            // MD StrSubstNo('%1\Images',topicFolder)
                            fMgmt.ServerCreateDirectory(StrSubstNo('%1\Images', topicFolder));
                        // sub.SetRange("Group Code.COL.US", topic."Group Code.COL.US");
                        // sub.SetRange("Group Version.COL.US", topic."Group Version.COL.US");
                        // sub.SetRange("Topic Code.COL.US", topic."Code.COL.US");
                        // sub.SetRange("Topic Type.COL.US", topic."Type.COL.US");
                        // sub.SetCurrentKey("Unit Number.COL.US");
                        // if sub.FindSet() then
                        //     repeat
                        //         // MD topicFolder + subtopic
                        //         fMgmt.ServerCreateDirectory(StrSubstNo('%1\%2', topicFolder, sub."Code.COL.US"));
                        //     until sub.Next() = 0;
                        until topic.Next() = 0;
                until groups.Next() = 0;
            end;
        end;
    end;


    local procedure WriteSidebar(var toFile: File)
    var
        prevFilter: Text;
        grp: Record "Topic Group.COL.US";
        top: Record "Topics.COL.US";
    begin
        if grp.FindSet() then begin
            toFile.Write('<ul id="myUL">');
            toFile.Write(StrSubstNo('  <li><span class="caret"><a href="/%1/topics.html">Learning</a></span>', grp."Version.COL.US"));
            toFile.Write('  <ul class="nested">');
            repeat
                top.SetRange("Group Code.COL.US", grp."Code.COL.US");
                top.SetRange("Group Version.COL.US", grp."Version.COL.US");
                if top.FindSet() then begin
                    toFile.Write(StrSubstNo('  <li><span class="caret"><a href="/%1/%2/Learning/topics.html">%3</a></span>', grp."Version.COL.US", grp."Code.COL.US", grp."Name.COL.US"));
                    toFile.Write('    <ul class="nested">');
                    repeat
                        toFile.Write(StrSubstNo('<li><a href="/%1/%2/Learning/%3/topic_overview.html">%4</a></li>', grp."Version.COL.US", grp."Code.COL.US", top."Code.COL.US", top."Name.COL.US"));
                    until top.Next() = 0;
                    toFile.Write('    </ul>');
                end else
                    toFile.Write(StrSubstNo('  <li><a href="/%1/%2/Learning/topics.html">%3</a>', grp."Version.COL.US", grp."Code.COL.US", grp."Name.COL.US"));
                toFile.Write('  </li>');
            until grp.Next() = 0;
            toFile.Write('  </ul>');
            toFile.Write('</ul">');
        end;
    end;

}