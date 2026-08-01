/**
 * Product detail: chọn màu / size -> gán productVariantID, giá, tồn kho.
 * Thứ tự gallery: Ảnh chính → Ảnh phụ (imgDesc) → Ảnh biến thể (variant).
 * Tất cả ảnh của mọi biến thể (cả màu và size) đều được load lên.
 * Khi chọn màu hoặc size -> nhảy đến ảnh của biến thể tương ứng.
 */
(function () {
    var variants = window.MB_PRODUCT_VARIANTS || [];
    var ctx = window.MB_CTX || "";
    var defaultId = window.MB_DEFAULT_VARIANT_ID || 0;
    var mainImg = window.MB_MAIN_IMG || "";
    var L = window.MB_LABELS || {};
    var CUR = L.currency || "VN\u0111";

    var $colorWrap = document.getElementById("mb-color-options");
    var $sizeSelect = document.getElementById("mb-size-select");
    var $sizeOptions = document.getElementById("mb-size-options");
    var $colorName = document.getElementById("mb-color-name");
    var $sizeName = document.getElementById("mb-size-name");
    var $wishVariant = document.getElementById("mb-wish-variant-id");
    var $variantInput = document.getElementById("mb-variant-id");
    var $qty = document.getElementById("number");
    var $stock = document.getElementById("mb-stock-label");
    var $priceBox = document.getElementById("mb-detail-price");
    var $addBtn = document.getElementById("mb-add-cart-btn");
    var $noVariant = document.getElementById("mb-no-variant-msg");

    if (!variants.length) {
        if ($noVariant) {
            $noVariant.style.display = "block";
        }
        if ($addBtn) {
            $addBtn.disabled = true;
        }
        return;
    }

    var active = variants.filter(function (v) {
        return v.status === 1 || v.status === undefined;
    });
    if (!active.length) {
        active = variants;
    }

    // Build unique color list
    var colors = [];
    var colorMap = {};
    active.forEach(function (v) {
        var cid = v.colorOptionID;
        if (!colorMap[cid]) {
            colorMap[cid] = {
                id: cid,
                name: v.colorName || "Màu",
                hex: v.colorHex || "#cccccc"
            };
            colors.push(colorMap[cid]);
        }
    });

    var selectedColorId = null;
    var selectedVariantId = null;

    // Map: variantID -> slide index in the Slick slider
    var variantSlideMap = {};
    var slickReady = false;

    function resolveImgSrc(img) {
        if (!img) return "";
        var src = img;
        if (img.indexOf("http") !== 0) {
            if (ctx && img.indexOf(ctx + "/") === 0) {
                src = img;
            } else if (img.indexOf("/") === 0) {
                src = ctx + img;
            } else {
                src = ctx + "/" + img.replace(/^\.\//, "");
            }
        }
        return src;
    }

    function formatPrice(n) {
        n = parseFloat(n) || 0;
        return n.toLocaleString("vi-VN");
    }

    function findVariant(colorId, sizeId) {
        return active.find(function (v) {
            return v.colorOptionID === colorId && v.sizeOptionID === sizeId;
        });
    }

    function applyVariant(v) {
        if (!v) {
            return;
        }
        selectedVariantId = v.ID;
        if ($variantInput) {
            $variantInput.value = v.ID;
        }
        var qty = v.quantity || 0;
        if ($qty) {
            $qty.max = Math.max(qty, 1);
            if (parseInt($qty.value, 10) > qty) {
                $qty.value = qty > 0 ? qty : 1;
            }
            $qty.disabled = qty <= 0;
        }
        if ($stock) {
            if (qty > 0) {
                $stock.textContent = (L.inStock || "C\u00f2n h\u00e0ng") + " (" + qty + ")";
            } else {
                $stock.textContent = L.outStock || "H\u1ebft h\u00e0ng";
            }
        }
        if ($addBtn) {
            $addBtn.disabled = qty <= 0;
        }
        if ($wishVariant) {
            $wishVariant.value = v.ID;
        }
        if ($colorName && v.colorName) {
            $colorName.textContent = v.colorName;
        }
        if ($sizeName && v.sizeLabel) {
            $sizeName.textContent = v.sizeLabel;
        }
        if ($priceBox) {
            var newP = v.newPrice > 0 ? v.newPrice : v.oldPrice;
            var oldP = v.oldPrice;
            var html = "<span class=\"mb-pd-price-current\">" + formatPrice(newP) + " " + CUR + "</span>";
            if (v.newPrice > 0 && oldP > newP) {
                html += "<span class=\"mb-pd-price-old\">" + formatPrice(oldP) + " " + CUR + "</span>";
                var pct = Math.round((1 - newP / oldP) * 100);
                if (pct > 0) {
                    html += "<span class=\"mb-pd-badge-sale\">-" + pct + "%</span>";
                }
            }
            $priceBox.innerHTML = html;
        }

        // Navigate slider to this variant's image (if slick is ready)
        goToVariantSlide(v.ID);
    }

    /**
     * Navigate slider to the image corresponding to the selected variant.
     */
    function goToVariantSlide(variantId) {
        if (!slickReady || !window.jQuery) return;

        var slideIdx = variantSlideMap[variantId];
        if (slideIdx === undefined || slideIdx === null) {
            slideIdx = 0; // fallback to main image
        }

        var $mainImg = jQuery('#product-main-img');
        var $thumbImgs = jQuery('#product-imgs');

        if ($mainImg.length && $mainImg.hasClass('slick-initialized')) {
            $mainImg.slick('slickGoTo', slideIdx);
        }
        if ($thumbImgs.length && $thumbImgs.hasClass('slick-initialized')) {
            $thumbImgs.slick('slickGoTo', slideIdx);
        }
    }

    function renderSizes(colorId) {
        if ($sizeSelect) {
            $sizeSelect.innerHTML = "";
        }
        if ($sizeOptions) {
            $sizeOptions.innerHTML = "";
        }
        var sizes = [];
        active.forEach(function (v) {
            if (v.colorOptionID === colorId) {
                var exists = sizes.some(function (s) {
                    return s.id === v.sizeOptionID;
                });
                if (!exists) {
                    sizes.push({
                        id: v.sizeOptionID,
                        label: v.sizeLabel || "Size",
                        qty: v.quantity || 0,
                    });
                }
            }
        });
        sizes.forEach(function (s, idx) {
            if ($sizeSelect) {
                var opt = document.createElement("option");
                opt.value = s.id;
                opt.textContent = s.label;
                $sizeSelect.appendChild(opt);
            }
            if ($sizeOptions) {
                var btn = document.createElement("button");
                btn.type = "button";
                btn.className = "mb-pd-size-btn" + (idx === 0 ? " active" : "");
                btn.textContent = s.label;
                btn.disabled = s.qty <= 0;
                btn.setAttribute("data-size-id", s.id);
                btn.addEventListener("click", function () {
                    if ($sizeSelect) {
                        $sizeSelect.value = s.id;
                    }
                    $sizeOptions.querySelectorAll(".mb-pd-size-btn").forEach(function (b) {
                        b.classList.toggle("active", b === btn);
                    });
                    applyVariant(findVariant(colorId, parseInt(s.id, 10)));
                });
                $sizeOptions.appendChild(btn);
            }
        });
        if (sizes.length) {
            if ($sizeSelect) {
                $sizeSelect.value = sizes[0].id;
            }
            applyVariant(findVariant(colorId, parseInt(sizes[0].id, 10)));
        }
    }

    function selectColor(colorId) {
        selectedColorId = colorId;
        var c = colorMap[colorId];
        if ($colorName && c) {
            $colorName.textContent = c.name;
        }
        if ($colorWrap) {
            $colorWrap.querySelectorAll(".mb-variant-swatch").forEach(function (btn) {
                btn.classList.toggle("active", parseInt(btn.getAttribute("data-color-id"), 10) === colorId);
            });
        }
        
        // renderSizes will automatically select the first available size and call applyVariant
        // which in turn will trigger goToVariantSlide
        renderSizes(colorId);
    }

    // Render color swatches immediately
    if ($colorWrap) {
        colors.forEach(function (c, idx) {
            var btn = document.createElement("button");
            btn.type = "button";
            btn.className = "mb-variant-swatch mb-pd-swatch" + (idx === 0 ? " active" : "");
            btn.setAttribute("data-color-id", c.id);
            btn.title = c.name;
            var hex = c.hex;
            if (hex && hex.indexOf("#") !== 0) {
                hex = "#" + hex;
            }
            btn.style.backgroundColor = hex || "#ccc";
            btn.addEventListener("click", function () {
                selectColor(c.id);
            });
            $colorWrap.appendChild(btn);
        });
    }

    if ($sizeSelect) {
        $sizeSelect.addEventListener("change", function () {
            if (selectedColorId != null) {
                applyVariant(findVariant(selectedColorId, parseInt($sizeSelect.value, 10)));
            }
        });
    }

    // Set initial variant data (price, stock, etc.) immediately - no Slick needed
    var initial = active.find(function (v) {
        return v.ID === defaultId;
    }) || active[0];
    if (initial) {
        selectColor(initial.colorOptionID);
        if ($sizeSelect) {
            $sizeSelect.value = initial.sizeOptionID;
            applyVariant(initial);
        }
    } else if (colors.length) {
        selectColor(colors[0].id);
    }

    /**
     * Inject ALL unique variant images into the Slick slider.
     * Thứ tự: Ảnh chính (slide 0) → Ảnh phụ imgDesc (slide 1..N) → Ảnh variant (cuối cùng).
     * Must be called AFTER Slick is initialized (inside $(document).ready).
     */
    function injectVariantImages() {
        if (!window.jQuery) return;

        var $mainSlider = jQuery('#product-main-img');
        var $thumbSlider = jQuery('#product-imgs');
        var mainSlickInit = $mainSlider.length && $mainSlider.hasClass('slick-initialized');
        var thumbSlickInit = $thumbSlider.length && $thumbSlider.hasClass('slick-initialized');

        if (!mainSlickInit && !thumbSlickInit) {
            active.forEach(function (v) {
                variantSlideMap[v.ID] = 0;
            });
            slickReady = true;
            return;
        }

        var existingSlideCount = 0;
        if (mainSlickInit) {
            existingSlideCount = $mainSlider.slick('getSlick').slideCount;
        }

        // Collect unique images from ALL variants
        var seenSrcs = {};
        var mainSrc = resolveImgSrc(mainImg);
        if (mainSrc) {
            seenSrcs[mainSrc] = true;
        }

        var existingSlides = document.querySelectorAll('#product-main-img .slick-slide:not(.slick-cloned) img');
        existingSlides.forEach(function (el) {
            if (el.src) {
                seenSrcs[el.src] = true;
            }
        });

        var uniqueImgs = []; // list of { src: string, variantIds: [id1, id2], name: string }
        
        active.forEach(function (v) {
            if (v.variantImg) {
                var src = resolveImgSrc(v.variantImg);
                if (src && !seenSrcs[src]) {
                    seenSrcs[src] = true;
                    uniqueImgs.push({ src: src, variantIds: [v.ID], name: v.colorName + " " + v.sizeLabel });
                } else if (src && seenSrcs[src]) {
                    var existingItem = uniqueImgs.find(function(item) { return item.src === src; });
                    if (existingItem) {
                        existingItem.variantIds.push(v.ID);
                    } else {
                        // Image already in gallery (e.g. main image or imgDesc)
                        var foundIdx = findExistingSlideIndex($mainSlider, src);
                        if (foundIdx >= 0) {
                            variantSlideMap[v.ID] = foundIdx;
                        }
                    }
                }
            }
        });

        // Add variant images at the END of the slider
        for (var i = 0; i < uniqueImgs.length; i++) {
            var item = uniqueImgs[i];
            var mainSlideHtml = '<div class="product-preview" data-variant-ids="' + item.variantIds.join(',') + '">' +
                '<a data-fancybox="product-gallery" href="' + item.src + '">' +
                '<img class="mb-img" src="' + item.src + '" alt="' + item.name + '" onerror="mbImgOnError(this)"/>' +
                '</a></div>';
            var thumbSlideHtml = '<div class="product-preview" data-variant-ids="' + item.variantIds.join(',') + '">' +
                '<img class="mb-img" src="' + item.src + '" alt="' + item.name + '" onerror="mbImgOnError(this)"/>' +
                '</div>';

            if (mainSlickInit) {
                $mainSlider.slick('slickAdd', mainSlideHtml); // no index = add at END
            }
            if (thumbSlickInit) {
                $thumbSlider.slick('slickAdd', thumbSlideHtml); // no index = add at END
            }

            var newIdx = existingSlideCount + i;
            item.variantIds.forEach(function(vid) {
                variantSlideMap[vid] = newIdx;
            });
        }

        // For variants with no image, fallback to 0 (main image)
        active.forEach(function (v) {
            if (variantSlideMap[v.ID] === undefined) {
                variantSlideMap[v.ID] = 0;
            }
        });

        slickReady = true;

        // Reset to slide 0 (main image) upon load
        if (mainSlickInit) {
            $mainSlider.slick('slickGoTo', 0);
        }
        if (thumbSlickInit) {
            $thumbSlider.slick('slickGoTo', 0);
        }
    }

    function findExistingSlideIndex($slider, src) {
        if (!$slider.length || !$slider.hasClass('slick-initialized')) return -1;
        var idx = -1;
        $slider.find('.slick-slide:not(.slick-cloned)').each(function () {
            var img = this.querySelector('img');
            if (img && img.src === src) {
                idx = parseInt(jQuery(this).attr('data-slick-index'), 10);
                return false; 
            }
        });
        return idx;
    }

    if (window.jQuery) {
        jQuery(document).ready(function () {
            setTimeout(function () {
                injectVariantImages();
            }, 150);
        });
    } else {
        window.addEventListener('load', function () {
            setTimeout(function () {
                if (window.jQuery) {
                    injectVariantImages();
                }
            }, 300);
        });
    }

    var form = document.querySelector("form[action*='cart/add']");
    if (form) {
        form.addEventListener("submit", function (e) {
            var vid = $variantInput ? $variantInput.value : "";
            if (!vid || parseInt(vid, 10) <= 0) {
                e.preventDefault();
                var msg = "Vui lòng chọn màu và size trước khi thêm vào giỏ.";
                if (typeof Swal !== "undefined") {
                    Swal.fire({
                        icon: "warning",
                        title: "Chọn biến thể",
                        text: msg,
                        confirmButtonColor: "#D10024",
                    });
                } else {
                    alert(msg);
                }
            }
        });
    }

    var params = new URLSearchParams(window.location.search);
    if (params.get("act") === "add-cart") {
        var st = params.get("status");
        var title = "Giỏ hàng";
        var text = "Không thể thêm vào giỏ.";
        var icon = "error";
        if (st === "1") {
            text = "Đã thêm vào giỏ hàng.";
            icon = "success";
        } else if (st === "2") {
            text = "Số lượng vượt tồn kho.";
            icon = "warning";
        }
        if (typeof Swal !== "undefined") {
            Swal.fire({ icon: icon, title: title, text: text, confirmButtonColor: "#D10024" });
        }
    }
})();
